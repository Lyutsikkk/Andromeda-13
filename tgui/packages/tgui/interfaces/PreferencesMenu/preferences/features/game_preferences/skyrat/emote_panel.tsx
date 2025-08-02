// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const emote_panel: FeatureToggle = {
  name: 'Панель эмоций',
  category: 'ЧАТ',
  description:
    'Переключает панель эмоций (для применения необходимо переподключиться, если вы находитесь в игре)',
  component: CheckboxInput,
};
