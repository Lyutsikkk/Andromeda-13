import {
  CheckboxInput,
  Feature,
  FeatureChoiced,
  FeatureChoicedServerData,
  FeatureNumberInput,
  FeatureNumeric,
  FeatureToggle,
  FeatureTriBoolInput,
  FeatureTriColorInput,
  FeatureValueProps,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const scaled_appearance: FeatureToggle = {
  name: '(Тело) Чёткость внешнего вида',
  description: 'Придайте своему персонажу резкий или нечеткий вид.',
  component: CheckboxInput,
};

export const feature_butt: Feature<string> = {
  name: '(Задница) Выбор задницы',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const butt_skin_tone: FeatureToggle = {
  name: '(Задница) Использовать Тон кожи',
  component: CheckboxInput,
};

export const butt_skin_color: FeatureToggle = {
  name: '(Задница) Использовать Цвет кожи',
  component: CheckboxInput,
};

export const butt_color: Feature<string[]> = {
  name: '(Задница) Цвет задницы',
  component: FeatureTriColorInput,
};

export const butt_emissive: Feature<boolean[]> = {
  name: '(Задница) Свечение задницы',
  description: 'Детали светятся в темноте.',
  component: FeatureTriBoolInput,
};

export const butt_size: FeatureNumeric = {
  name: '(Задница) Размер задницы',
  component: FeatureNumberInput,
};

export const anus_skin_tone: FeatureToggle = {
  name: '(Анус) Использовать Тон кожи',
  component: CheckboxInput,
};

export const anus_skin_color: FeatureToggle = {
  name: '(Анус) Использовать Цвет кожи',
  component: CheckboxInput,
};

export const anus_color: Feature<string[]> = {
  name: '(Анус) Цвет Ануса',
  component: FeatureTriColorInput,
};

export const anus_emissive: Feature<boolean[]> = {
  name: '(Анус) Свечение ануса',
  description: 'Детали светятся в темноте.',
  component: FeatureTriBoolInput,
};

export const feature_belly: Feature<string> = {
  name: '(Живот) Выбор живота',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const belly_size: FeatureNumeric = {
  name: '(Живот) Размер живота',
  component: FeatureNumberInput,
};

export const belly_skin_tone: FeatureToggle = {
  name: '(Живот) Использовать Тон кожи',
  component: CheckboxInput,
};

export const belly_skin_color: FeatureToggle = {
  name: '(Живот) Использовать Цвет кожи',
  component: CheckboxInput,
};

export const belly_color: Feature<string[]> = {
  name: '(Живот) Цвет живота',
  component: FeatureTriColorInput,
};

export const belly_emissive: Feature<boolean[]> = {
  name: '(Живот) Свечение живота',
  description: 'Детали светятся в темноте.',
  component: FeatureTriBoolInput,
};

export const erp_status_pref_extm: FeatureChoiced = {
  name: '(ЕРП) Экстремальное ЕРП',
  component: FeatureDropdownInput,
};

export const erp_status_pref_extmharm: FeatureChoiced = {
  name: '(ЕРП) Максимально экстремальное ЕРП',
  component: FeatureDropdownInput,
};

export const erp_status_pref_unholy: FeatureChoiced = {
  name: '(ЕРП) Грязное ЕРП',
  component: FeatureDropdownInput,
};

export const erp_lust_tolerance_pref: FeatureNumeric = {
  name: '(ЕРП-МЕХАН) Множитель толерантности к похоти',
  description:
    'Установите множитель толерантности похоти. \n(0.5 = половинная толерантность, 2 = двойная толерантность)',
  component: FeatureNumberInput,
};

export const erp_sexual_potency_pref: FeatureNumeric = {
  name: '(ЕРП-МЕХАН) Множитель сексуальной потенции',
  description:
    'Установите множитель сексуальной потенции. \n(0.5 = половина потенции, 2 = двойная потенция)',
  component: FeatureNumberInput,
};

// Genital fluid preferences
export const testicles_fluid: FeatureChoiced = {
  name: '(Яички) Жидкость яичек',
  description: 'Тип жидкости, вырабатываемой яичками.',
  component: FeatureDropdownInput,
};

export const breasts_fluid: FeatureChoiced = {
  name: '(Грудь) Жидкость груди',
  description: 'Тип жидкости, вырабатываемой грудью.',
  component: FeatureDropdownInput,
};

export const vagina_fluid: FeatureChoiced = {
  name: '(Вагина) Жидкость влагины',
  description: 'Тип жидкости, вырабатываемой влагалищем.',
  component: FeatureDropdownInput,
};

export const cumflates_partners_pref: FeatureToggle = {
  name: 'Кончать от партнёров',
  description: 'Ваш персонаж кончает с партнером.',
  component: CheckboxInput,
};
