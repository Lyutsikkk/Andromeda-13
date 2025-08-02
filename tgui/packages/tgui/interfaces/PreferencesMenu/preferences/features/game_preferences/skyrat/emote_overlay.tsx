// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const do_emote_overlay: FeatureToggle = {
  name: 'Показать/скрыть оверлей моих эффектов эмоций',
  category: 'ЧАТ',
  description:
    'Это показывает/скрывает анимированные оверлеи, отображаемые в эмоциях.',
  component: CheckboxInput,
};
