<template>
  <fieldset>
    <legend>Otu</legend>
    <smart-selector
      v-model="otu"
      model="otus"
      klass="AssertedDistribution"
      target="AssertedDistribution"
      ref="smartSelector"
      pin-section="Otus"
      pin-type="Otu"
      :search="true"
      :autocomplete="false"
      :otu-picker="true">
      <template v-if="otu">
        <p class="horizontal-left-content">
          <span data-icon="ok"/>
          <span v-html="otu.object_tag"/>
          <span
            class="button circle-button btn-undo button-default"
            @click="unset"/>
        </p>
      </template>
    </smart-selector>
  </fieldset>
</template>

<script>

import SmartSelector from 'components/ui/SmartSelector'

export default {
  components: { SmartSelector },

  props: {
    modelValue: {
      type: Object,
      default: undefined
    }
  },

  emits: ['update:modelValue'],

  computed: {
    otu: {
      get () {
        return this.modelValue
      },
      set (value) {
        this.$emit('update:modelValue', value)
      }
    }
  },

  methods: {
    refresh () {
      this.$refs.smartSelector.refresh()
    },
    unset () {
      this.otu = undefined
    }
  }
}
</script>

<style scoped>
  li {
    margin-bottom: 8px;
  }
</style>
