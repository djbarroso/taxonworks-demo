<template>
  <div>
    <div class="horizontal-left-content">
      <label>
        Amount:
        <input
          type="number"
          :value="continuousValue"
          @input="updateContinuousValue"
        >
      </label>
      <unit-selector
        class="margin-small-right"
        v-model="continuousUnit"
      />
      <TimeFields
        inline
        :row-object="rowObject"
        :observation="observation"
      />
      <template v-if="observation.id">
        <radial-annotator :global-id="observation.global_id" />
        <v-btn
          color="destroy"
          circle
          @click="removeObservation"
        >
          <v-icon
            x-small
            name="trash"
          />
        </v-btn>
      </template>
    </div>
  </div>
</template>

<script>
import { MutationNames } from '../../store/mutations/mutations'
import { ActionNames } from '../../store/actions/actions'
import UnitSelector from '../UnitSelector/UnitSelector.vue'
import RadialAnnotator from 'components/radials/annotator/annotator.vue'
import VBtn from 'components/ui/VBtn/index.vue'
import VIcon from 'components/ui/VIcon/index.vue'
import TimeFields from '../Time/TimeFields.vue'

export default {
  components: {
    UnitSelector,
    RadialAnnotator,
    TimeFields,
    VBtn,
    VIcon
  },

  props: {
    rowObject: {
      type: Object,
      required: true
    },

    observation: {
      type: Object,
      required: true
    }
  },

  computed: {
    continuousValue () {
      return this.observation.continuousValue
    },

    continuousUnit: {
      get () {
        return this.observation.continuousUnit
      },
      set (unit) {
        this.$store.commit(MutationNames.SetContinuousUnit, {
          rowObjectId: this.rowObject.id,
          rowObjectType: this.rowObject.type,
          observationId: this.observation.id || this.observation.internalId,
          continuousUnit: unit
        })
      }
    }
  },

  methods: {
    updateContinuousValue (event) {
      this.$store.commit(MutationNames.SetContinuousValue, {
        rowObjectId: this.rowObject.id,
        rowObjectType: this.rowObject.type,
        continuousValue: event.target.value,
        observationId: this.observation.id || this.observation.internalId
      })
    },

    removeObservation () {
      this.$store.dispatch(ActionNames.RemoveObservation, {
        rowObjectId: this.rowObject.id,
        rowObjectType: this.rowObject.type,
        obsId: this.observation.id
      })
    }
  }
}
</script>
