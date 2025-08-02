import { CheckboxInput, type FeatureToggle } from '../../base';

export const see_credits: FeatureToggle = {
  name: 'Смотреть итоги зачесления',
  category: 'ГЕЙМПЛЕЙ',
  description:
    'Если эта функция включена, вы увидите последовательность начисления кредитов в конце раунда.',
  component: CheckboxInput,
};
