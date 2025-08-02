// THIS IS A SKYRAT UI FILE
import {
  CheckboxInput,
  type Feature,
  type FeatureChoiced,
  type FeatureChoicedServerData,
  FeatureNumberInput,
  type FeatureNumeric,
  type FeatureToggle,
  FeatureTriBoolInput,
  FeatureTriColorInput,
  type FeatureValueProps,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const feature_penis: Feature<string> = {
  name: '(Пенис) Выбор пениса',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const penis_skin_tone: FeatureToggle = {
  name: '(Пенис) Использовать Тон кожи',
  component: CheckboxInput,
};

export const penis_skin_color: FeatureToggle = {
  name: '(Пенис) Использовать Цвет кожи',
  component: CheckboxInput,
};

export const penis_color: Feature<string[]> = {
  name: '(Пенис) Цвет пениса',
  component: FeatureTriColorInput,
};

export const penis_emissive: Feature<boolean[]> = {
  name: '(Пенис) Свечение пениса',
  description: 'Детали светятся в темноте.',
  component: FeatureTriBoolInput,
};

export const penis_sheath: Feature<string> = {
  name: '(Пенис) Оболочка пениса',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const penis_length: FeatureNumeric = {
  name: '(Пенис) Длина пениса',
  description:
    'Значение измеряется в дюймах.\
     Это значение ограничено 20 для персонажей с размером тела <= 1 \
     или без признака чрезмерной величины. Максимально допустимое значение увеличивается\
     в зависимости от размера тела персонажа, вплоть до 36.',
  component: FeatureNumberInput,
};

export const penis_girth: FeatureNumeric = {
  name: '(Пенис) Обхват пениса',
  description:
    'Значение - это окружность, измеряемая в дюймах.\
    Это значение ограничено 15 для персонажей с размером тела <= 1 \
    или без признака чрезмерной величины. Максимально допустимое значение увеличивается\
    в зависимости от размера тела персонажа, до максимального значения 20.',
  component: FeatureNumberInput,
};

export const penis_taur_mode_toggle: FeatureToggle = {
  name: '(Пенис) Режим пениса Таура',
  description:
    'Если у выбранного тела тавра есть спрайт пениса, он будет использован \
    вместо обычного.',
  component: CheckboxInput,
};

export const feature_testicles: Feature<string> = {
  name: '(Яички) Выбор яичек',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const testicles_skin_tone: FeatureToggle = {
  name: '(Яички) Использовать Тон кожи',
  component: CheckboxInput,
};

export const testicles_skin_color: FeatureToggle = {
  name: '(Яички) Использовать Цвет кожи',
  component: CheckboxInput,
};

export const testicles_color: Feature<string[]> = {
  name: '(Яички) Цвет яичек',
  component: FeatureTriColorInput,
};

export const testicles_emissive: Feature<boolean[]> = {
  name: '(Яички) Свечение яичек',
  description: 'Детали светятся в темноте.',
  component: FeatureTriBoolInput,
};

export const balls_size: FeatureNumeric = {
  name: '(Яички) Размер яичек',
  component: FeatureNumberInput,
};

export const feature_vagina: Feature<string> = {
  name: '(Вагина) Выбор вагины',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const vagina_skin_tone: FeatureToggle = {
  name: '(Вагина) Использовать Тон кожи',
  component: CheckboxInput,
};

export const vagina_skin_color: FeatureToggle = {
  name: '(Вагина) Использовать Цвет кожи',
  component: CheckboxInput,
};

export const vagina_color: Feature<string[]> = {
  name: '(Вагина) Цвет вагины',
  component: FeatureTriColorInput,
};

export const vagina_emissive: Feature<boolean[]> = {
  name: '(Вагина) Свечение вагины',
  description: 'Детали светятся в темноте.',
  component: FeatureTriBoolInput,
};

export const feature_womb: Feature<string> = {
  name: '(Вагина) Выбор матки',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_breasts: Feature<string> = {
  name: '(Грудь) Выбор груди',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const breasts_skin_tone: FeatureToggle = {
  name: '(Грудь) Использовать Тон кожи',
  component: CheckboxInput,
};

export const breasts_skin_color: FeatureToggle = {
  name: '(Грудь) Использовать Цвет кожи',
  component: CheckboxInput,
};

export const breasts_color: Feature<string[]> = {
  name: '(Грудь) Цвет груди',
  component: FeatureTriColorInput,
};

export const breasts_emissive: Feature<boolean[]> = {
  name: '(Грудь) Свечение груди',
  description: 'Детали светятся в темноте.',
  component: FeatureTriBoolInput,
};

export const breasts_lactation_toggle: FeatureToggle = {
  name: '(Грудь) Грудная лактация',
  component: CheckboxInput,
};

export const breasts_size: Feature<string> = {
  name: '(Грудь) Размер груди',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_anus: Feature<string> = {
  name: '(Анус) Выбор ануса',
  component: FeatureDropdownInput,
};

export const body_size: FeatureNumeric = {
  name: '(Тело) Размер тела',
  component: FeatureNumberInput,
};

export const erp_status_pref: FeatureChoiced = {
  name: '(ЕРП) Статус ЕРП',
  description:
    'Все предпочтения по статусу ЕРП являются лишь маркерами для других игроков \
  о ваших предпочтениях в отношении различных широких категорий ЕРП. Выбрав «нет», вы практически изолируете себя от \
  всех направленных ЕРП.',
  component: FeatureDropdownInput,
};

export const erp_status_pref_nc: FeatureChoiced = {
  name: '(ЕРП) Статус ЕРП Non-Con (изнасилование)',
  component: FeatureDropdownInput,
};

export const erp_status_pref_v: FeatureChoiced = {
  name: '(ЕРП) Статус ЕРП воре',
  component: FeatureDropdownInput,
};

export const erp_status_pref_hypnosis: FeatureChoiced = {
  name: '(ЕРП) Статус ЕРП гипноза',
  component: FeatureDropdownInput,
};

export const erp_status_pref_mechanics: FeatureChoiced = {
  name: '(ЕРП) Статус ЕРП механа',
  component: FeatureDropdownInput,
};
