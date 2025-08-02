import {
  type Feature,
  type FeatureChoiced,
  FeatureShortTextInput,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const pda_theme: FeatureChoiced = {
  name: '(КПК) Тема для КПК',
  category: 'ГЕЙМПЛЕЙ',
  component: FeatureDropdownInput,
};

export const pda_ringtone: Feature<string> = {
  name: '(КПК) Мелодия КПК',
  component: FeatureShortTextInput,
};
