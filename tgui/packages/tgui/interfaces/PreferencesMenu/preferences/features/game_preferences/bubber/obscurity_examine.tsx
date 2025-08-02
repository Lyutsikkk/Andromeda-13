import { CheckboxInput, type FeatureToggle } from '../../base';

export const obscurity_examine_pref: FeatureToggle = {
  name: 'Неизвестная панель осмотра',
  category: 'ГЕЙМПЛЕЙ',
  description:
    'Определяет, будет ли ваша панель проверки скрыта, если она неизвестна.',
  component: CheckboxInput,
};
