<script>

import { GetterNames } from '../../store/getters/getters.js'
import { MutationNames } from '../../store/mutations/mutations.js'
import { User } from 'routes/endpoints'

export default {
  computed: {
    preferences: {
      get () {
        return this.$store.getters[GetterNames.GetPreferences]
      },
      set (value) {
        this.$store.commit(MutationNames.SetPreferences, value)
      }
    },

    componentsOrder: {
      get () {
        return this.$store.getters[GetterNames.GetComponentsOrder][this.componentsSection]
      },
      set (value) {
        this.$store.commit(MutationNames.SetComponentsOrder, Object.assign({}, this.$store.getters[GetterNames.GetComponentsOrder], { [this.componentsSection]: value }))
      }
    }
  },

  data () {
    return {
      keyStorage: '',
      componentsSection: ''
    }
  },

  watch: {
    preferences: {
      handler (newVal) {
        const storedOrder = this.preferences.layout[this.keyStorage]

        if (storedOrder &&
          this.componentsOrder.length === storedOrder.length &&
          this.componentsOrder.every(item => storedOrder.includes(item))
        ) {
          this.componentsOrder = this.preferences.layout[this.keyStorage]
        }
      },
      deep: true
    }
  },

  methods: {
    updatePreferences () {
      User.update(this.preferences.id, { user: { layout: { [this.keyStorage]: this.componentsOrder } } }).then(response => {
        this.preferences.layout = response.body.preferences
        this.componentsOrder = response.body.preferences.layout[this.keyStorage]
      })
    }
  }
}
</script>