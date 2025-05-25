import { CheckboxInput, FeatureToggle } from '../base';

export const persistent_scars: FeatureToggle = {
  name: '(ПЕРСОНАЖ) Стойкие шрамы',
  description:
    'Если флажок установлен, шрамы будут сохраняться все раунды, если вы доживете до конца.',
  component: CheckboxInput,
};
