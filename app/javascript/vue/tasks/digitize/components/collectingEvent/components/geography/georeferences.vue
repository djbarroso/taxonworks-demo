<template>
  <div>
    <button
      @click="openModal"
      type="button"
      :disabled="!collectingEvent.id"
      class="button normal-input button-default margin-small-right">
      Georeferences
      <template v-if="count > 0">
        ({{ count }})
      </template>
    </button>
    <button
      v-if="!verbatimGeoreferenceAlreadyCreated"
      type="button"
      class="button normal-input button-submit"
      :disabled="!collectingEvent.id || !existCoordinates"
      @click="createVerbatimShape()">
      Create georeference from verbatim
    </button>
    <template v-if="verbatimGeoreferenceAlreadyCreated">
      <span>Lat: {{ verbatimLat }}, Long: {{ verbatimLng }}<span v-if="georeferenceVerbatimRadiusError">, Radius error: {{ georeferenceVerbatimRadiusError }}</span></span>
    </template>
    <modal-component
      class="modal-georeferences"
      @close="closeModal"
      v-if="show">
      <template #header>
        <h3>Georeferences</h3>
      </template>
      <template #body>
        <div
          :style="{
            maxHeight: '80vh',
            overflowY: 'scroll'
          }">
          <div class="horizontal-left-content margin-medium-top margin-medium-bottom">
            <wtk-component
              class="margin-small-right"
              @create="saveWTK"/>
            <manually-component
              class="margin-small-right"
              @create="saveGeoreference($event, GEOREFERENCE_POINT)"/>
            <geolocate-component
              class="margin-small-right"
              @create="createGEOLocate"/>
            <button
              type="button"
              v-if="verbatimLat && verbatimLng"
              :disabled="verbatimGeoreferenceAlreadyCreated"
              @click="createVerbatimShape"
              class="button normal-input button-submit">
              Create georeference from verbatim
            </button>
          </div>
          <div>
            <spinner-component
              v-if="isLoading"
              :legend="!collectingEvent.id ? 'Need collecting event ID' : 'Saving...'"/>
            <map-component
              height="500px"
              width="auto"
              :geojson="shapes"
              :lat="lat"
              :lng="lng"
              :zoom="3"
              :zoom-bounds="8"
              fit-bounds
              resize
              draw-controls
              :draw-polyline="false"
              :cut-polygon="false"
              :removal-mode="false"
              @geoJsonLayersEdited="updateGeoreference($event)"
              @geoJsonLayerCreated="saveGeoreference($event)"/>
          </div>
          <div class="margin-medium-top">
            <b>Georeference date</b>
            <date-component
              v-model:day="date.day_georeferenced"
              v-model:month="date.month_georeferenced"
              v-model:year="date.year_georeferenced"
            />
          </div>
          <div class="horizontal-left-content margin-medium-top margin-medium-bottom">
            <wtk-component
              class="margin-small-right"
              @create="saveWTK"/>
            <manually-component
              class="margin-small-right"
              @create="saveGeoreference($event, GEOREFERENCE_POINT)"/>
            <geolocate-component
              class="margin-small-right"
              @create="createGEOLocate"/>
            <button
              type="button"
              v-if="verbatimLat && verbatimLng"
              :disabled="verbatimGeoreferenceAlreadyCreated"
              @click="createVerbatimShape"
              class="button normal-input button-submit">
              Create georeference from verbatim
            </button>
          </div>
          <display-list
            :list="georeferences"
            @delete="removeGeoreference"
            @updateGeo="updateRadius"
            @dateChanged="updateDate"
            label="object_tag"/>
        </div>
      </template>
    </modal-component>
  </div>
</template>

<script>

import ModalComponent from 'components/ui/Modal'
import { GetterNames } from '../../../../store/getters/getters.js'
import { MutationNames } from '../../../../store/mutations/mutations.js'
import { ActionNames } from '../../../../store/actions/actions.js'

import MapComponent from 'components/georeferences/map.vue'
import SpinnerComponent from 'components/spinner.vue'
import DisplayList from 'components/georeferences/list.vue'
import ManuallyComponent from 'components/georeferences/manuallyComponent'
import GeolocateComponent from 'components/georeferences/geolocateComponent'
import DateComponent from 'components/ui/Date/DateFields.vue'
import WtkComponent from 'tasks/collecting_events/new_collecting_event/components/parsed/georeferences/wkt.vue'
import { Georeference } from 'routes/endpoints'
import {
  GEOREFERENCE_GEOLOCATE,
  GEOREFERENCE_LEAFLET,
  GEOREFERENCE_VERBATIM,
  GEOREFERENCE_POINT
} from 'constants/index.js'
import { truncateDecimal } from 'helpers/math.js'
import { addToArray } from 'helpers/arrays.js'
import convertDMS from 'helpers/parseDMS.js'

export default {
  components: {
    ModalComponent,
    MapComponent,
    SpinnerComponent,
    DisplayList,
    ManuallyComponent,
    GeolocateComponent,
    WtkComponent,
    DateComponent
  },

  emits: ['onModal'],

  computed: {
    collectingEvent () {
      return this.$store.getters[GetterNames.GetCollectingEvent]
    },

    lat () {
      return parseFloat(this.collectingEvent.verbatim_latitude)
    },

    lng () {
      return parseFloat(this.collectingEvent.verbatim_longitude)
    },

    existCoordinates () {
      const lat = this.collectingEvent.verbatim_latitude
      const lng = this.collectingEvent.verbatim_longitude

      return convertDMS(lat) && convertDMS(lng)
    },

    geolocationUncertainty () {
      return this.$store.getters[GetterNames.GetCollectingEvent].verbatim_geolocation_uncertainty
    },

    verbatimLat () {
      return this.verbatimGeoreferenceAlreadyCreated
        ? truncateDecimal(this.verbatimGeoreferenceAlreadyCreated.geo_json.geometry.coordinates[1], 6)
        : this.collectingEvent.verbatim_latitude
    },

    verbatimLng () {
      return this.verbatimGeoreferenceAlreadyCreated
        ? truncateDecimal(this.verbatimGeoreferenceAlreadyCreated.geo_json.geometry.coordinates[0], 6)
        : this.collectingEvent.verbatim_longitude
    },

    georeferenceVerbatimRadiusError () {
      return this.verbatimGeoreferenceAlreadyCreated?.geo_json?.properties?.radius
    },

    geographicArea () {
      return this.$store.getters[GetterNames.GetGeographicArea]?.shape
    },

    verbatimGeoreferenceAlreadyCreated () {
      return this.georeferences.find(item => item.type === GEOREFERENCE_VERBATIM)
    },

    georeferences: {
      get () {
        return this.$store.getters[GetterNames.GetGeoreferences]
      },
      set (value) {
        this.$store.commit(MutationNames.SetGeoreferences, value)
      }
    },

    count () {
      return this.georeferences.length
    },

    GEOREFERENCE_POINT () {
      return GEOREFERENCE_POINT
    }
  },

  data () {
    return {
      show: false,
      shapes: [],
      creatingShape: false,
      isLoading: false,
      date: {
        year_georeferenced: undefined,
        day_georeferenced: undefined,
        month_georeferenced: undefined
      }
    }
  },

  watch: {
    georeferences: {
      handler () {
        this.populateShapes()
      },
      deep: true
    },
    geographicArea: {
      handler () {
        this.populateShapes()
      },
      deep: true
    }
  },

  methods: {
    openModal () {
      this.show = true
      this.$emit('onModal', this.show)
    },

    closeModal () {
      this.show = false
      this.$emit('onModal', this.show)
    },

    runSoftValidations () {
      this.$store.dispatch(ActionNames.LoadSoftValidations)
    },

    updateRadius (shape) {
      const georeference = {
        id: shape.id,
        error_radius: shape.error_radius,
        error_geographic_item_id: shape.geographic_item_id
      }
      this.isLoading = true

      Georeference.update(shape.id, { georeference }).then(_ => {
        this.populateShapes()
      }).finally(() => {
        this.isLoading = false
      })
    },

    saveWTK (georeference) {
      georeference.collecting_event_id = this.collectingEvent.id
      this.isLoading = true

      Georeference.create({ georeference }).then(({ body }) => {
        if (body.error_radius) {
          body.geo_json.properties.radius = body.error_radius
        }
        this.georeferences.push(body)
      }).finally(() => {
        this.isLoading = false
      })
    },

    saveGeoreference (shape, type = GEOREFERENCE_LEAFLET) {
      const georeference = {
        geographic_item_attributes: { shape: JSON.stringify(shape) },
        error_radius: shape.properties?.radius,
        collecting_event_id: this.collectingEvent.id,
        type,
        ...this.date
      }

      this.isLoading = true
      Georeference.create({ georeference }).then(response => {
        if (response.body.error_radius) {
          response.body.geo_json.properties.radius = response.body.error_radius
        }
        this.georeferences.push(response.body)
      }).finally(() => {
        this.isLoading = false
      })
    },

    updateGeoreference (shape, type = GEOREFERENCE_LEAFLET) {
      const georeference = {
        id: shape.properties.georeference.id,
        error_radius: shape.properties?.radius,
        geographic_item_attributes: { shape: JSON.stringify(shape) },
        collecting_event_id: this.collectingEvent.id,
        type
      }

      this.isLoading = true
      Georeference.update(georeference.id, { georeference }).then(response => {
        const index = this.georeferences.findIndex(geo => geo.id === response.body.id)

        this.georeferences[index] = response.body
      }).finally(() => {
        this.isLoading = false
      })
    },

    populateShapes () {
      const shapes = []

      if (this.geographicArea) {
        shapes.unshift(this.geographicArea)
      }
      this.georeferences.forEach(geo => {
        if (geo.error_radius != null) {
          geo.geo_json.properties.radius = geo.error_radius
        }
        shapes.push(geo.geo_json)
      })

      this.shapes = shapes
    },

    removeGeoreference ({ id }) {
      Georeference.destroy(id).then(() => {
        this.georeferences.splice(this.georeferences.findIndex(item => item.id === id), 1)
      })
    },

    createVerbatimShape () {
      if (this.verbatimGeoreferenceAlreadyCreated || this.creatingShape) return
      const shape = {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Point',
          coordinates: [convertDMS(this.verbatimLng), convertDMS(this.verbatimLat)]
        }
      }
      const georeference = {
        geographic_item_attributes: { shape: JSON.stringify(shape) },
        collecting_event_id: this.collectingEvent.id,
        type: GEOREFERENCE_VERBATIM,
        error_radius: this.geolocationUncertainty
      }

      this.creatingShape = true
      this.isLoading = true

      Georeference.create({ georeference }).then(({ body }) => {
        this.georeferences.push(body)

        TW.workbench.alert.create('Georeference was successfully created.', 'notice')
      }).finally(() => {
        this.isLoading = false
        this.creatingShape = false
      })
    },

    createGEOLocate (iframe_data) {
      this.isLoading = true
      Georeference.create({
        georeference: {
          iframe_response: iframe_data,
          collecting_event_id: this.collectingEvent.id,
          type: GEOREFERENCE_GEOLOCATE
        }
      }).then(response => {
        this.georeferences.push(response.body)
      }).finally(() => {
        this.isLoading = false
      })
    },

    updateDate ({ id, year_georeferenced, month_georeferenced, day_georeferenced}) {
      const georeference = {
        year_georeferenced,
        month_georeferenced,
        day_georeferenced
      }

      this.isLoading = true

      Georeference.update(id, { georeference })
        .then(({ body }) => { addToArray(this.georeferences, body) })
        .finally(() => { this.isLoading = false })
    }
  }
}
</script>

<style lang="scss">
  .modal-georeferences {
    .modal-container {
      width: 500px;
    }
  }
</style>
