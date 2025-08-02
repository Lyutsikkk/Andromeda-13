import {
  CheckboxInput,
  type Feature,
  FeatureColorInput,
  type FeatureToggle,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

// SPLURT EDIT START
export const use_tgui_player_panel: FeatureToggle = {
  name: 'Используйте современную панель проигрывателя',
  category: 'АДМИН',
  description: 'Использовать ли новую панель плеера TGUI или старую HTML.',
  component: CheckboxInput,
};
// SPLURT EDIT END

export const asaycolor: Feature<string> = {
  name: 'Цвет админских сообщений',
  category: 'АДМИН',
  description: 'Цвет ваших сообщений в Adminsay.',
  component: FeatureColorInput,
};

export const brief_outfit: Feature<string> = {
  name: 'Экипировка для брифинга',
  category: 'АДМИН',
  description: 'Экипировка, выдаваемая вам на роли брифинг офицера.',
  component: FeatureDropdownInput,
};

export const bypass_deadmin_in_centcom: FeatureToggle = {
  name: 'Игнорировать deadmin при спавне на ЦК',
  category: 'АДМИН',
  description:
    'Оставаться ли с правами администратора, когда вы появляетесь на ЦК.',
  component: CheckboxInput,
};

export const fast_mc_refresh: FeatureToggle = {
  name: 'Включить ускоренное обновление MC',
  category: 'АДМИН',
  description:
    'Должна ли панель MC со стат-панели обновляться быстрее обычного. Используйте, только если она нужна!',
  component: CheckboxInput,
};

export const ghost_roles_as_admin: FeatureToggle = {
  name: 'Получать гост-роли будучи админом',
  category: 'АДМИН',
  description: `
    Если вы отключите это, то вы не будете получать предложения о гост-ролях,
    когда вы с правами администратора. НИКАКОЕ оповещение не будет повляться для вас.
    Но эта опция ничего не делает, если вы являетесь обычным игроком
    (deadmin).
`,
  component: CheckboxInput,
};

export const comms_notification: FeatureToggle = {
  name: 'Звуковое оповещение о факсах на ЦК',
  category: 'АДМИН',
  component: CheckboxInput,
};

export const auto_deadmin_on_ready_or_latejoin: FeatureToggle = {
  name: 'Авто deadmin - Готов или Позднее подключение',
  category: 'АДМИН',
  description: `
    Если эта функция включена, вы будете автоматически дедминить, когда нажмете кнопку готовности или позднего присоединения к раунду.
`,
  component: CheckboxInput,
};
