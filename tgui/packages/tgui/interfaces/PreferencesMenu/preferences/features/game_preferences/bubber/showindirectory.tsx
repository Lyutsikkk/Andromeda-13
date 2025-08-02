import { CheckboxInput, type FeatureToggle } from '../../base';

export const show_in_directory: FeatureToggle = {
  name: 'Показать в каталоге',
  category: 'ПОДРОБНЕЕ',
  description: 'Если включено, персонаж будет показан в справочнике',
  component: CheckboxInput,
};
