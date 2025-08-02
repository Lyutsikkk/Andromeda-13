// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const looc_admin_pref: FeatureToggle = {
  name: 'Видеть удаленный LOOC',
  category: 'АДМИН',
  description:
    'Определяет, хотите ли вы видеть LOOC где-либо в качестве администратора или нет.',
  component: CheckboxInput,
};

export const enable_looc_runechat: FeatureToggle = {
  name: 'Включить LOOC рунчата',
  category: 'РУНЧАТ',
  description:
    'Если это значение равно TRUE, LOOC появится как над головой говорящего, так и в чате.',
  component: CheckboxInput,
};
