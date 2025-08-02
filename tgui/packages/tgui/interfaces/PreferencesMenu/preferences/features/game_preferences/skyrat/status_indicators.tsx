import { CheckboxInput, type FeatureToggle } from '../../base';

export const enable_status_indicators: FeatureToggle = {
  name: 'Индикаторы состояния дисплея',
  category: 'ГЕЙМПЛЕЙ',
  description: 'Это переключает, будут ли отображаться индикаторы состояния.',
  component: CheckboxInput,
};
