// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const soulcatcher_overlays: FeatureToggle = {
  name: 'Оверлей душеловки',
  category: 'ГЕЙМПЛЕЙ',
  description:
    'Если включить эту функцию, вы будете видеть полноэкранные оверлеи, находясь в душеловке?',
  component: CheckboxInput,
};
