import { FeatureChoiced } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const show_flavor_text_nsfw: FeatureChoiced = {
  name: '(ПЕРСОНАЖ) Видимость описания внешности NSFW',
  description:
    'Как вы хотите, чтобы отображался текст NSFW. Синты всегда показывают NSFW-текст, если не установлено значение «никогда».',
  category: 'ЕРП',
  component: FeatureDropdownInput,
};
