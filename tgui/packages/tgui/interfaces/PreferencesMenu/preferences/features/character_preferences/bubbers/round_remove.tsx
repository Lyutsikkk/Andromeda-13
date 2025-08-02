import { CheckboxInput, type FeatureToggle } from '../../base';

export const be_round_removed: FeatureToggle = {
  name: '(ПЕРСОНАЖ) Быть гибнутым в раунде',
  description:
    'Показывает другим игрокам, что вы не против быть гибнутым (безвозвратно убиты) в раунде.',
  component: CheckboxInput,
};
