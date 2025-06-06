import { CheckboxInput, FeatureToggle } from '../base';

export const darkened_flash: FeatureToggle = {
  name: 'Включение затемненных вспышек',
  category: 'ДОСТУПНОСТЬ',
  description: `
    При переключении на мигающий экран будет отображаться темный экран, а не
    яркий.
  `,
  component: CheckboxInput,
};

export const screen_shake_darken: FeatureToggle = {
  name: 'Уменьшить дрожание экрана',
  category: 'ДОСТУПНОСТЬ',
  description: `
      Если этот параметр включен, то при сотрясении экрана экран темнеет.
    `,
  component: CheckboxInput,
};

export const remove_double_click: FeatureToggle = {
  name: 'Remove double click',
  category: 'ACCESSIBILITY',
  description: `
      When toggled, actions that require a double click will instead offer
      alternatives, good if you have a not-so-functional mouse.
    `,
  component: CheckboxInput,
};
