<template>
  <div>
    <div class="field">
      <label>Group</label>
      <autocomplete
        url="https://paleobiodb.org/data1.2/strata/auto.json"
        min="3"
        label="name"
        nested="records"
        :send-label="collectingEvent.group"
        @getItem="collectingEvent.group = $event.name"
        :headers="externalHeaders"
        :add-params="{
          limit: 30,
          vocab: 'pbdb',
          rank: 'group'
        }"
        param="name"/>
    </div>
    <div class="field">
      <label>Formation</label>
      <autocomplete
        url="https://paleobiodb.org/data1.2/strata/auto.json"
        min="3"
        label="name"
        nested="records"
        :send-label="collectingEvent.formation"
        @getItem="collectingEvent.formation = $event.name"
        :headers="externalHeaders"
        :add-params="{
          limit: 30,
          vocab: 'pbdb',
          rank: 'formation'
        }"
        param="name"/>
    </div>
    <div class="field label-above">
      <label>Member</label>
      <input
        type="text"
        v-model="collectingEvent.member">
    </div>
    <div class="field label-above">
      <label>Lithology</label>
      <input
        type="text"
        v-model="collectingEvent.lithology">
    </div>
    <div class="horizontal-left-content ma-fields">
      <div class="separate-right label-above">
        <label>Minumum MA</label>
        <input
          type="text"
          v-model="collectingEvent.min_ma">
      </div>
      <div class="separate-left label-above">
        <label>Maximum MA</label>
        <input
          type="text"
          v-model="collectingEvent.max_ma">
      </div>
    </div>
  </div>
</template>

<script>

import Autocomplete from 'components/ui/Autocomplete.vue'
import extendCE from '../mixins/extendCE'

export default {
  mixins: [extendCE],
  components: {
    Autocomplete
  },
  data() {
    return {
      externalHeaders: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .ma-fields {
    input {
      width: 60px;
    }
  }
</style>
