// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const auto_dementor_pref: FeatureToggle = {
  name: 'Авто dementor',
  category: 'АДМИН',
  description:
    'Когда эта функция включена, вы автоматически становитесь dementor.',
  component: CheckboxInput,
};
