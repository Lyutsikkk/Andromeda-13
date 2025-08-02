// THIS IS A SKYRAT UI FILE
import { CheckboxInput, type FeatureToggle } from '../../base';

export const face_cursor_combat_mode: FeatureToggle = {
  name: 'Следить за курсором',
  category: 'ГЕЙМПЛЕЙ',
  description: `
    При переключении вы будете стоять лицом к курсору,
    если включён режим боя.
  `,
  component: CheckboxInput,
};
