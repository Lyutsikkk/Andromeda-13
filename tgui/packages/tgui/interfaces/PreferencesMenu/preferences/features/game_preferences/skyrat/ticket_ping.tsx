// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const ticket_ping_pref: FeatureToggle = {
  name: 'Тикет пинг',
  category: 'АДМИН',
  description:
    'Если эта функция включена, вы будете получать регулярные сообщения от необработанных заявок.',
  component: CheckboxInput,
};
