// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const soulcatcher_join_action: FeatureToggle = {
  name: 'Присоединяйтесь к ивенту душегуба',
  category: 'ПРИЗРАК',
  description:
    'Переключает, хотите ли вы, чтобы действие присоединения к ловцу душ в качестве призрака было показано вам. Вы все равно будете иметь доступ к ивенту, независимо от этого.',
  component: CheckboxInput,
};
