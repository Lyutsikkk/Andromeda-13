// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const delete_sparks_pref: FeatureToggle = {
  name: 'Искры удаления',
  category: 'АДМИН',
  description:
    'Переключается, если вы хотите воспроизвести зажигательную анимацию при удалении объектов от имени администратора.',
  component: CheckboxInput,
};
