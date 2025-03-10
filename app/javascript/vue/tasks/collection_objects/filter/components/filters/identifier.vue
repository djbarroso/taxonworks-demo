<template>
  <div>
    <h3>Identifiers</h3>
    <div class="field">
      <label>Identifier</label>
      <br>
      <input 
        type="text"
        v-model="identifier.identifier">
    </div>
    <h4>Namespace</h4>
    <smart-selector
      class="margin-small-top"
      model="namespaces"
      klass="CollectionObject"
      pin-section="Namespaces"
      pin-type="Namespace"
      @selected="setNamespace"/>
    <div
      v-if="namespace"
      class="middle flex-separate separate-top">
      <span v-html="namespace.name"/>
      <span
        class="button button-circle btn-undo button-default"
        @click="unsetNamespace"/>
    </div>
    <div class="field">
      <h4>Match</h4>
      <ul class="no_bullets">
        <li
          v-for="item in match"
          :key="item.value">
          <label>
            <input
              type="radio"
              :value="item.value"
              v-model="identifier.identifier_exact"
              name="match-radio">
            {{ item.label }}
          </label>
        </li>
      </ul>
    </div>
    <h4>In range</h4>
    <div class="horizontal-left-content">
      <div class="field separate-right">
        <label>Start:</label>
        <br>
        <input
          type="text"
          v-model="identifier.identifier_start">
      </div>
      <div class="field">
        <label>End:</label>
        <br>
        <input
          type="text"
          v-model="identifier.identifier_end">
      </div>
    </div>
  </div>
</template>

<script>

import SmartSelector from 'components/ui/SmartSelector'
import { URLParamsToJSON } from 'helpers/url/parse.js'
import { Namespace } from 'routes/endpoints'

export default {
  components: { SmartSelector },

  props: {
    modelValue: {
      type: Object,
      required: true
    }
  },

  emits: ['update:modelValue'],

  computed: {
    identifier: {
      get () {
        return this.modelValue
      },
      set (value) {
        this.$emit('update:modelValue', value)
      }
    }
  },

  watch: {
    identifier: {
      handler (newVal) {
        if (!newVal.identifier || !newVal.identifier.length) {
          this.identifier.identifier_exact = undefined
        }
      },
      deep: true
    }
  },

  data () {
    return {
      smartLists: {},
      view: undefined,
      options: [],
      namespace: undefined,
      match: [
        {
          label: 'Exact',
          value: true
        },
        {
          label: 'Partial',
          value: undefined
        }
      ]
    }
  },

  mounted () {
    const urlParams = URLParamsToJSON(location.href)

    this.identifier.identifier = urlParams.identifier
    this.identifier.identifier_exact = urlParams.identifier_exact
    this.identifier.identifier_start = urlParams.identifier_start
    this.identifier.identifier_end = urlParams.identifier_end
    if (urlParams.namespace_id) {
      Namespace.find(urlParams.namespace_id).then(response => {
        this.setNamespace(response.body)
      })
    }
  },

  methods: {
    setNamespace (namespace) {
      this.namespace = namespace
      this.identifier.namespace_id = namespace.id
    },
    unsetNamespace () {
      this.namespace = undefined
      this.identifier.namespace_id = undefined
    }
  }
}
</script>

<style scoped>
  :deep(.vue-autocomplete-input) {
    width: 100%
  }
</style>
