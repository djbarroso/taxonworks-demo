<template>
  <div class="matches-panel">
    <spinner-component
      v-if="searching"
      legend="Searching..."
    />
    <div class="panel padding-medium-left padding-medium-right">
      <display-list
        v-if="founded.length"
        :list="founded"
        label="object_tag"
        :remove="false"
        :edit="true"
        @edit="source = $event"
      />
    </div>
  </div>
</template>

<script>

import { GetterNames } from '../store/getters/getters'
import { MutationNames } from '../store/mutations/mutations'
import { Source } from 'routes/endpoints'
import DisplayList from 'components/displayList'
import SpinnerComponent from 'components/spinner'

export default {
  components: {
    DisplayList,
    SpinnerComponent
  },

  computed: {
    source: {
      get () {
        return this.$store.getters[GetterNames.GetSource]
      },
      set (value) {
        return this.$store.commit(MutationNames.SetSource, value)
      }
    },

    saving () {
      return this.$store.getters[GetterNames.GetSettings].saving
    }
  },

  data () {
    return {
      founded: [],
      oldVal: undefined,
      delay: 1000,
      timer: undefined,
      searching: false
    }
  },

  watch: {
    source: {
      handler (newVal) {
        if (!newVal.title) {
          clearTimeout(this.timer)
          this.searching = false
          this.founded = []
        } else if (newVal.title !== this.oldVal) {
          this.searching = true
          clearTimeout(this.timer)
          this.timer = setTimeout(() => { this.getRecent() }, this.delay)
        }
        this.oldVal = newVal.title
      },
      deep: true,
      immediate: true
    },

    saving (newVal) {
      if (!newVal) {
        this.getRecent()
      }
    }
  },

  methods: {
    getRecent () {
      this.searching = true
      Source.where({ query_term: this.source.title, per: 5 }).then(({ body }) => {
        this.founded = this.source.id
          ? body.filter(item => item.id !== this.source.id)
          : body
      }).finally(() => {
        this.searching = false
      })
    }
  }
}
</script>
