import {
  CheckboxInput,
  Feature,
  FeatureColorInput,
  FeatureToggle,
} from '../../base';

export const custom_blood_color: FeatureToggle = {
  name: '(Кровь) Настройки цвета крови',
  component: CheckboxInput,
};

export const blood_color: Feature<string> = {
  name: '(Кровь) Пользовательский цвет крови',
  component: FeatureColorInput,
};
