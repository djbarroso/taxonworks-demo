<template>
  <div>
    <label>Label</label>
    <textarea
      rows="5"
      @blur="searchCE"
      v-model="collectingEvent.verbatim_label"/>
    <clone-label/>
    <modal-component
      v-if="showModal"
      @close="showModal = false">
      <template #header>
        <h3>Collecting events match</h3>
      </template>
      <template #body>
        <i>As edited this Collecting Event is invalid: a matching verbatim label has been found.</i>
        <table class="full_width">
          <thead>
            <tr>
              <th>Label</th>
              <th />
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="item in CEFounded"
              :key="item.id">
              <td v-html="item.object_tag"/>
              <td class="horizontal-right-content">
                <span
                  class="button btn-edit circle-button button-default"
                  @click="loadCE(item)"/>
              </td>
            </tr>
          </tbody>
        </table>
      </template>
    </modal-component>
  </div>
</template>

<script>

import { GetterNames } from '../../../../store/getters/getters'
import { MutationNames } from '../../../../store/mutations/mutations'
import { CollectingEvent } from 'routes/endpoints'
import CloneLabel from './cloneLabel'
import ModalComponent from 'components/ui/Modal'
import extendCE from '../../mixins/extendCE.js'

export default {
  mixins: [extendCE],
  components: {
    CloneLabel,
    ModalComponent
  },

  computed: {
    label () {
      return this.$store.getters[GetterNames.GetCollectingEvent].verbatim_label
    },
    collectingEvent () {
      return this.$store.getters[GetterNames.GetCollectingEvent]
    }
  },

  data () {
    return {
      showModal: false,
      CEFounded: []
    }
  },

  methods: {
    searchCE () {
      if (this.label) {
        CollectingEvent.where({
          md5_verbatim_label: true,
          in_labels: this.label
        }).then(response => {
          if (response.body.length) {
            this.CEFounded = response.body
            if (!response.body.find(item => item.id === this.collectingEvent.id)) {
              this.showModal = true
            }
          }
        })
      }
    },

    loadCE (ce) {
      this.$store.commit(MutationNames.SetCollectingEvent, ce)
      this.showModal = false
    }
  }
}
</script>
<style lang="scss" scoped>
  :deep(.modal-container) {
    max-width: 500px;
  }
</style>
