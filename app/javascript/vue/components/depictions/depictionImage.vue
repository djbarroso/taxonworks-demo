<template>
  <div class="depiction-thumb-container">
    <modal
      v-if="viewMode"
      @close="viewMode = false">
      <template #header>
        <h3>View</h3>
      </template>
      <template #body>
        <div class="horizontal-left-content align-start">
          <div class="full_width">
            <img
              class="img-maxsize"
              :src="depiction.image.image_file_url">
            <div class="horizontal-left-content">
              <radial-annotator :global-id="depiction.image.global_id"/>
              Annotate image
              <radial-navigation :global-id="depiction.image.global_id"/>
              Navigate image
            </div>
          </div>
          <div class="margin-medium-left full_width">
            <h3>Image depicts a {{ depiction.depiction_object_type }}</h3>
            <div class="field separate-top label-above">
              <label>Figure label</label>
              <input
                v-model="depiction.figure_label"
                type="text"
                placeholder="Label">
            </div>
            <div class="field separate-bottom label-above">
              <label>Caption</label>
              <markdown-editor
                v-model="depiction.caption"
                :configs="config"
                ref="etymologyText"/>
            </div>
            <div class="margin-small-bottom">
              <label>
                <input
                  v-model="depiction.is_metadata_depiction"
                  type="checkbox">
                Is metadata
              </label>
            </div>
            <div class="flex-separate">
              <button
                type="button"
                @click="updateDepiction"
                class="normal-input button button-submit">Save
              </button>
              <button
                type="button"
                @click="deleteDepiction"
                class="normal-input button button-delete">Delete</button>
            </div>
          </div>
        </div>
      </template>
    </modal>
    <img
      class="img-thumb"
      @click="viewMode = true"
      :src="depiction.image.alternatives.thumb.image_file_url"
      :height="depiction.image.alternatives.thumb.height"
      :width="depiction.image.alternatives.thumb.width">
    <div class="horizontal-left-content">
      <span
        class="circle-button btn-edit button-default"
        @click="viewMode = true"/>
      <span
        class="circle-button btn-delete"
        @click="deleteDepiction"/>
    </div>
  </div>
</template>
<script>

import { Depiction } from 'routes/endpoints'
import Modal from 'components/ui/Modal.vue'
import RadialAnnotator from 'components/radials/annotator/annotator'
import RadialNavigation from 'components/radials/navigation/radial'
import MarkdownEditor from 'components/markdown-editor.vue'

const Tabs = {
  MARKDOWN: 'markdown',
  CAPTION: 'caption'
}

export default {
  components: {
    Modal,
    RadialAnnotator,
    RadialNavigation,
    MarkdownEditor
  },

  props: {
    depiction: {
      type: Object,
      required: true
    }
  },

  emits: ['delete'],

  data () {
    return {
      fullSizeImage: false,
      viewMode: false,
      tabSelected: undefined,
      tabs: Object.values(Tabs),
      config: {
        status: false,
        spellChecker: false
      }
    }
  },

  methods: {
    updateDepiction () {
      const depiction = {
        caption: this.depiction.caption,
        figure_label: this.depiction.figure_label,
        is_metadata_depiction: this.depiction.is_metadata_depiction
      }

      Depiction.update(this.depiction.id, { depiction }).then(_ => {
        TW.workbench.alert.create('Depiction was successfully updated.', 'notice')
      })
    },

    deleteDepiction () {
      this.$emit('delete', this.depiction)
    }
  }
}
</script>
<style lang="scss">
.depiction-thumb-container {
  .img-thumb {
     cursor: pointer;
  }
  .img-maxsize {
    transition: all 0.5s ease;
    max-width: 100%;
    max-height: 60vh;
  }
  .img-fullsize {
    cursor: zoom-out
  }
  .img-normalsize {
    cursor: zoom-in
  }
  .field {
    input, textarea {
     width: 100%
   }
  }
  .CodeMirror {
    min-height: 100px;
    height: 100px;
  }
  .modal-container {
    width: auto;
  }
}
</style>
