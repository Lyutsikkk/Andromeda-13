import { CheckboxInput, type FeatureToggle } from '../../base';

export const be_antag_pref: FeatureToggle = {
  name: 'Быть антагонистом',
  category: 'ГЕЙМПЛЕЙ',
  description: 'Определяет, хотите ли вы быть антагонистом или нет.',
  component: CheckboxInput,
};
