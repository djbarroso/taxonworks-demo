<template>
  <HandyScroll>
    <div>
      <table
        ref="tableBar"
        v-resize-column
      >
        <thead>
          <tr>
            <th>
              <tag-all
                :ids="ids"
                type="CollectionObject"
                class="separate-right"/>
            </th>
            <th>Collection object</th>
            <template
              v-for="(item, index) in list.column_headers">
              <th
                v-if="index > 2"
                @click="sortTable(index)">{{item}}
              </th>
            </template>
          </tr>
        </thead>
        <tbody>
          <tr
            class="contextMenuCells"
            :class="{ even: indexR % 2 }"
            v-for="(row, indexR) in list.data"
            :key="row[0]">
            <td>
              <input
                v-model="ids"
                :value="row[0]"
                type="checkbox">
            </td>
            <td>
              <a
                :href="`/tasks/collection_objects/browse?collection_object_id=${row[0]}`"
                target="_blank">
                Show
              </a>
            </td>
            <template v-for="(item, index) in row">
              <td v-if="index > 2">
                <span>{{item}}</span>
              </td>
            </template>
          </tr>
        </tbody>
      </table>
    </div>
  </HandyScroll>
</template>

<script>

import { sortArray } from 'helpers/arrays.js'
import { vResizeColumn } from 'directives/resizeColumn.js'
import TagAll from './tagAll'
import HandyScroll from 'vue-handy-scroll'

export default {
  components: {
    TagAll,
    HandyScroll
  },

  directives: {
    ResizeColumn: vResizeColumn
  },

  props: {
    list: {
      type: Object,
      default: undefined
    },
    modelValue: {
      type: Array,
      default: () => []
    }
  },

  emits: [
    'onSort',
    'update:modelValue'
  ],

  computed: {
    ids: {
      get () {
        return this.modelValue
      },
      set (value) {
        this.$emit('update:modelValue', value)
      }
    }
  },

  data () {
    return {
      ascending: false
    }
  },

  watch: {
    list: {
      handler () {
        HandyScroll.EventBus.emit('update', { sourceElement: this.$el })  
      },
      immediate: true
    }
  },

  methods: {
    sortTable (sortProperty) {
      this.$emit('onSort', sortArray(this.list.data, sortProperty, this.ascending))
      this.ascending = !this.ascending
    }
  }
}
</script>

<style lang="scss" scoped>

  tr {
    height: 44px;
  }
  .options-column {
    width: 130px;
  }
  .overflow-scroll {
    overflow: scroll;
  }

  td {
    max-width: 80px;
    overflow : hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  td:hover {
    max-width : 200px;
    text-overflow: ellipsis;
    white-space: normal;
  }
</style>
