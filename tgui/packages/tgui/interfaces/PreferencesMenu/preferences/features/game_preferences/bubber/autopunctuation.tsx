import { CheckboxInput, type FeatureToggle } from '../../base';

export const autopunctuation: FeatureToggle = {
  name: 'Автопунктуация',
  category: 'ЧАТ',
  description:
    'Если эта функция включена, в сообщениях, в которых отсутствуют знаки препинания, они будут добавлены.',
  component: CheckboxInput,
};
