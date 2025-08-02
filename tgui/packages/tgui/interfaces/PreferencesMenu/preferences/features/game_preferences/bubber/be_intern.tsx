import { CheckboxInput, type FeatureToggle } from '../../base';

export const be_intern: FeatureToggle = {
  name: 'Быть помеченным как Стажер (Новичёк)',
  category: 'ГЕЙМПЛЕЙ',
  description:
    'Определяет, будете ли вы отмечены как стажер на работах, где у вас мало игрового времени.',
  component: CheckboxInput,
};
