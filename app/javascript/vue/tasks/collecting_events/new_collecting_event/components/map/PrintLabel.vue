<template>
  <div>
    <label>Print label</label>
    <div class="flex-separate separate-bottom middle">
      <div>
        <button
          class="button normal-input button-default margin-small-right"
          @click="generateLabel">
          Generate
        </button>
        <button
          @click="copyLabel"
          class="button normal-input button-default"
          type="button"
          :disabled="!isEmpty">
          Copy verbatim label
        </button>
      </div>
      <label>Que to print
        <input
          class="que-input"
          :disabled="!(label.text && label.text.length)"
          size="5"
          v-model="label.total"
          type="number">
      </label>
      <a
        v-if="label.id && label.total > 0"
        target="blank"
        :href="`/tasks/labels/print_labels?label_id=${label.id}`">Preview
      </a>
    </div>
    <textarea
      v-model="label.text"
      cols="45"
      rows="12"/>
    <label>Document label</label>
    <textarea
      v-model="collectingEvent.document_label"
      cols="45"
      rows="6"/>
  </div>
</template>

<script>
import extendCE from '../mixins/extendCE.js'
import { GetterNames } from '../../store/getters/getters'
import { MutationNames } from '../../store/mutations/mutations'
import { parsedProperties } from '../../helpers/parsedProperties.js'
import { verbatimProperties } from '../../helpers/verbatimProperties.js'
import { sortArrayByArray } from 'helpers/arrays.js'

export default {
  mixins: [extendCE],
  computed: {
    isEmpty () {
      return this.label.text.length === 0
    },
    label: {
      get () {
        return this.$store.getters[GetterNames.GetCELabel]
      },
      set (value) {
        this.$store.commit(MutationNames.SetCELabel, value)
      }
    },
    tripCode () {
      return this.$store.getters[GetterNames.GetIdentifier]
    },
    georeferences () {
      return [].concat(this.$store.getters[GetterNames.GetGeoreferences], this.$store.getters[GetterNames.GetQueueGeoreferences])
    }
  },
  methods: {
    copyLabel () {
      this.label.text = this.collectingEvent.verbatim_label
    },

    generateVerbatimLabel () {
      return this.componentsOrder.componentVerbatim.map(componentName =>
        ({ [componentName]: 
          typeof verbatimProperties[componentName] !== 'function'
          ? this.collectingEvent[verbatimProperties[componentName]]
          : verbatimProperties[componentName](this.collectingEvent)
        })).filter(item => item)
    },

    generateParsedLabel () {
      return this.componentsOrder.componentParse
        .map(componentName => ({ [componentName]: parsedProperties[componentName] }))
        .filter(item => Object.values(item)[0])
        .map(item => {
          const [key, func] = Object.entries(item)[0]

          return {
            [key]: func({ ce: this.collectingEvent, tripCode: this.tripCode, georeferences: this.georeferences })
          }
        })
    },

    generateLabel () {
      const objectLabels = Object.assign({},
        ...this.generateVerbatimLabel(),
        ...this.generateParsedLabel()
      )

      const AtStart = [
        'TripIdentifier',
        'TripCode',
      ]

      const sortedObjectLabelKeys = sortArrayByArray(Object.keys(objectLabels), AtStart)
      const sortedLabels = sortedObjectLabelKeys.map(key => objectLabels[key]).filter(Boolean)

      this.label.text = [...new Set(sortedLabels)].join('\n')
    }
  }
}
</script>
<style scoped>
  textarea {
    width: 100%;
  }
  .que-input {
    width: 50px;
  }
</style>
