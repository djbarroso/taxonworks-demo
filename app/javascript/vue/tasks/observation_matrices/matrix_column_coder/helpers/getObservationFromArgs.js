import ComponentNames from '../helpers/ComponentNames'

export default function (state, args) {
  const {
    rowObjectId,
    characterStateId = null,
    internalId
  } = args

  const descriptor = state.descriptor

  if (descriptor.componentName === ComponentNames.Qualitative) {
    return state.observations.find(o => o.characterStateId === characterStateId && o.objectId === rowObjectId)
  } else if (descriptor.componentName === ComponentNames.Continuous) {
    return state.observations.find(o => o.internalId === internalId && o.objectId === rowObjectId)
  } else if (descriptor.componentName === ComponentNames.Sample) {
    return state.observations.find(o => o.internalId === internalId && o.objectId === rowObjectId)
  } else {
    return state.observations.find(o => o.objectId === rowObjectId)
  }
}
