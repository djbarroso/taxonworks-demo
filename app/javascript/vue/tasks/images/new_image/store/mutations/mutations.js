import addAttribution from './addAttribution'
import addDepiction from './addDepiction'
import addObjectForDepictions from './addObjectForDepictions'
import removeObjectForDepictions from './removeObjectForDepictions'
import setLicense from './setLicense'
import setImagesCreated from './setImagesCreated'
import setAuthors from './setAuthors'
import setEditors from './setEditors'
import setOwners from './setOwners'
import setCopyrightHolders from './setCopyrightHolder'
import setYearCopyright from './setYearCopyright'
import setDepictions from './setDepictions'
import setAttributionsCreated from './setAttributionsCreated'
import resetStore from './resetStore'

const MutationNames = {
  AddAttribution: 'addAttribution',
  AddDepiction: 'addDepiction',
  AddObjectForDepictions: 'addObjectForDepictions',
  RemoveObjectForDepictions: 'removeObjectForDepictions',
  SetLicense: 'setLicense',
  SetImagesCreated: 'setImagesCreated',
  SetAuthors: 'setAuthors',
  SetEditors: 'SetEditors',
  SetOwners: 'setOwners',
  SetCopyrightHolder: 'setCopyrightHolder',
  SetYearCopyright: 'setYearCopyright',
  SetDepictions: 'setDepictions',
  SetAttributionsCreated: 'setAttributionsCreated',
  ResetStore: 'resetStore'
}

const MutationFunctions = {
  [MutationNames.AddAttribution]: addAttribution,
  [MutationNames.AddDepiction]: addDepiction,
  [MutationNames.AddObjectForDepictions]: addObjectForDepictions,
  [MutationNames.RemoveObjectForDepictions]: removeObjectForDepictions,
  [MutationNames.SetLicense]: setLicense,
  [MutationNames.SetImagesCreated]: setImagesCreated,
  [MutationNames.SetAuthors]: setAuthors,
  [MutationNames.SetEditors]: setEditors,
  [MutationNames.SetOwners]: setOwners,
  [MutationNames.SetCopyrightHolder]: setCopyrightHolders,
  [MutationNames.SetYearCopyright]: setYearCopyright,
  [MutationNames.SetDepictions]: setDepictions,
  [MutationNames.SetAttributionsCreated]: setAttributionsCreated,
  [MutationNames.ResetStore]: resetStore
}

export {
  MutationNames,
  MutationFunctions
}
