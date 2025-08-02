import { CheckboxInput, type FeatureToggle } from '../../base';

export const ready_job: FeatureToggle = {
  name: 'Переключить готовность к работе',
  category: 'ИНТЕРФЕЙС',
  description:
    'Устанавливает, будет ли ваше самая высокая должность отображаться на панели оценки профессий перед игрой.',
  component: CheckboxInput,
};
