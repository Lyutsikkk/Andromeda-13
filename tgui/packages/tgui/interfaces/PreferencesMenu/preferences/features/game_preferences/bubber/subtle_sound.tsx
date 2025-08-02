import { CheckboxInput, type FeatureToggle } from '../../base';

export const subtler_sound: FeatureToggle = {
  name: 'Переключение звуков эмоций',
  category: 'ЗВУК',
  description: 'Переключает, слышите ли вы звуковые эффекты эмоций',
  component: CheckboxInput,
};
