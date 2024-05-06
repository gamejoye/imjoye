import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'

export function startAbility(delegator: abilityDelegatorRegistry.AbilityDelegator, bundleName: string, abilityName: string) {
  return delegator.executeShellCommand(`aa start -b ${bundleName} -a ${abilityName}`).then(result =>{
    console.info('Uitest, start ability finished:' + JSON.stringify(result))
  }).catch(err => {
    console.info('Uitest, start ability failed: ' + JSON.stringify(err))
  })
}