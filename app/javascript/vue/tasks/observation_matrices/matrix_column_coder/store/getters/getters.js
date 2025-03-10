import doesRowObjectNeedCountdown from './doesRowObjectNeedCountdown.js'
import getCharacterStateChecked from './getCharacterStateChecked.js'
import getFreeTextValueFor from './getFreeTextValueFor.js'
import getNextColumn from './getNextColumn.js'
import getObservationMatrix from './getObservationMatrix.js'
import getObservations from './getObservations.js'
import getObservationsFor from './getObservationsFor.js'
import getPresenceFor from './getPresenceFor'
import getPreviousColumn from './getPreviousColumn.js'
import getRowObjects from './getRowObjects.js'
import getUnits from './getUnits'
import isRowObjectSaving from './isRowObjectSaving.js'
import isRowObjectUnsaved from './isRowObjectUnsaved.js'

const GetterNames = {
  DoesRowObjectNeedCountdown: 'doesRowObjectNeedCountdown',
  GetCharacterStateChecked: 'getCharacterStateChecked',
  GetFreeTextValueFor: 'getFreeTextValueFor',
  GetNextColumn: 'getNextColumn',
  GetObservationMatrix: 'getObservationMatrix',
  GetObservations: 'getObservations',
  GetObservationsFor: ' getObservationsFor',
  GetPresenceFor: 'getPresenceFor',
  GetPreviousColumn: 'getPreviousColumn',
  GetRowObjects: 'getRowObjects',
  IsRowObjectSaving: 'isRowObjectSaving',
  IsRowObjectUnsaved: 'isRowObjectUnsaved'
}

const GetterFunctions = {
  [GetterNames.DoesRowObjectNeedCountdown]: doesRowObjectNeedCountdown,
  [GetterNames.GetCharacterStateChecked]: getCharacterStateChecked,
  [GetterNames.GetFreeTextValueFor]: getFreeTextValueFor,
  [GetterNames.GetNextColumn]: getNextColumn,
  [GetterNames.GetObservationMatrix]: getObservationMatrix,
  [GetterNames.GetObservationsFor]: getObservationsFor,
  [GetterNames.GetObservations]: getObservations,
  [GetterNames.GetPresenceFor]: getPresenceFor,
  [GetterNames.GetPreviousColumn]: getPreviousColumn,
  [GetterNames.GetPreviousColumn]: getPreviousColumn,
  [GetterNames.GetRowObjects]: getRowObjects,
  [GetterNames.GetUnits]: getUnits,
  [GetterNames.IsRowObjectSaving]: isRowObjectSaving,
  [GetterNames.IsRowObjectUnsaved]: isRowObjectUnsaved
}

export {
  GetterNames,
  GetterFunctions
}
