// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const master_erp_pref: FeatureToggle = {
  name: 'Показать / Скрыть предпочтения ЕРП',
  category: 'ЕРП',
  description: 'Это показывает/скрывает предпочтения ERP.',
  component: CheckboxInput,
};

export const erp_pref: FeatureToggle = {
  name: 'Эротическое ролевое взаимодействие',
  category: 'ЕРП',
  description: 'Это информирует игроков о том, хотите ли вы участвовать в ERP.',
  component: CheckboxInput,
};

export const erp_sounds_pref: FeatureToggle = {
  name: 'ЕРП звуки',
  category: 'ЕРП',
  description:
    'Переключается, если вы хотите слышать звуки, издаваемые механиками ERP.',
  component: CheckboxInput,
};

export const bimbofication_pref: FeatureToggle = {
  name: 'Бимбофикация',
  category: 'ЕРП',
  description:
    'Переключается, если вы в состоянии реагировать на последствия бимбофикации.',
  component: CheckboxInput,
};

export const aphro_pref: FeatureToggle = {
  name: 'Афродизиак',
  category: 'ЕРП',
  description: 'Определяет, хотите ли вы получать эффекты афродизиаков',
  component: CheckboxInput,
};

export const sextoy_pref: FeatureToggle = {
  name: 'Взаимодействие с секс-игрушками',
  category: 'ЕРП',
  description: 'После включения вы сможете взаимодействовать с секс-игрушками.',
  component: CheckboxInput,
};

export const sextoy_sounds_pref: FeatureToggle = {
  name: 'Звуки секс-игрушек',
  category: 'ЕРП',
  description: 'Переключает, будете ли вы слышать звуки от секс-игрушек.',
  component: CheckboxInput,
};

export const vore_enable_pref: FeatureToggle = {
  name: 'Включить механ Vore',
  category: 'ЕРП',
  description: 'Переключается, если вы хотите использовать механику vore.',
  component: CheckboxInput,
};

// BUBBER EDIT START: MECHANICAL HYPNOSIS PREF
export const hypnosis_pref: FeatureToggle = {
  name: 'Гипноз',
  category: 'ЕРП',
  description:
    'Определяет, хотите ли вы разрешить использование гипноза/химических веществ для гипноза непристойным образом.',
  component: CheckboxInput,
};
// BUBBER EDIT END

export const breast_enlargement_pref: FeatureToggle = {
  name: 'Увеличение груди',
  category: 'ЕРП',
  description:
    'Определяет, хотите ли вы получить эффект от химикатов для увеличения груди.',
  component: CheckboxInput,
};

export const breast_shrinkage_pref: FeatureToggle = {
  name: 'Уменьшение груди',
  category: 'ЕРП',
  description:
    'Определяет, хотите ли вы получить эффект от химикатов для уменьшения груди.',
  component: CheckboxInput,
};

export const breast_removal_pref: FeatureToggle = {
  name: 'Полное уменьшение груди',
  category: 'ЕРП',
  description:
    'Определяет, хотите ли вы получить полный эффект от применения химических препаратов для уменьшения груди.',
  component: CheckboxInput,
};

export const penis_enlargement_pref: FeatureToggle = {
  name: 'Увеличение пениса',
  category: 'ЕРП',
  description:
    'Определите, хотите ли вы получить эффект от химических препаратов для увеличения пениса.',
  component: CheckboxInput,
};

export const penis_shrinkage_pref: FeatureToggle = {
  name: 'Уменьшение пениса',
  category: 'ЕРП',
  description:
    'Определите, хотите ли вы получить эффект от химических препаратов для уменьшения пениса.',
  component: CheckboxInput,
};

export const gender_change_pref: FeatureToggle = {
  name: 'Принудительное изменение пола',
  category: 'ЕРП',
  description: 'Определяет, хотите ли вы разрешить принудительную смену пола.',
  component: CheckboxInput,
};

export const autocum_pref: FeatureToggle = {
  name: 'Авто кончить',
  category: 'ЕРП',
  description:
    'Определяет, будете ли вы автоматически кончать, используя систему возбуждения или вам нужно сделать это вручную.',
  component: CheckboxInput,
};

export const autoemote_pref: FeatureToggle = {
  name: 'Авто эмоции',
  category: 'ЕРП',
  description:
    'Определяет, будете ли вы автоматически проявлять эмоции, используя систему возбуждения или вам нужно сделать это вручную.',
  component: CheckboxInput,
};

/* SPLURT EDIT REMOVAL - No
export const erp_sexuality_pref: FeatureChoiced = {
  name: 'Sexuality Preference',
  category: 'ЕРП',
  description:
    'Determines what sexual content you see, limited use. None will show all content.',
  component: FeatureDropdownInput,
};
*/ // SPLURT EDIT REMOVAL END

export const genitalia_removal_pref: FeatureToggle = {
  name: 'Удаление гениталий',
  category: 'ЕРП',
  description:
    'Если флажок установлен, это позволяет химикатам удалять существующие гениталии у вашего персонажа.',
  component: CheckboxInput,
};

export const new_genitalia_growth_pref: FeatureToggle = {
  name: 'Наращивание новых гениталий',
  category: 'ЕРП',
  description:
    'Если флажок установлен, это позволяет химикатам вырастить новые гениталии у вашего персонажа.',
  component: CheckboxInput,
};

export const vore_overlays: FeatureToggle = {
  name: 'Vore оверлеи',
  category: 'ЕРП',
  description:
    'Если включить эту функцию, то во время нахождения в душегубке вам будут показываться полноэкранные оверлеи vore?',
  component: CheckboxInput,
};

export const vore_overlay_options: FeatureToggle = {
  name: 'Vore оверлеи опции',
  category: 'ЕРП',
  description:
    'Хотите ли вы видеть полноэкранные оверлей vore в качестве опции к оверлей soulcatcher?',
  component: CheckboxInput,
};
