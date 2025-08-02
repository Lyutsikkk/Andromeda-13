import { useState } from 'react';
import { Button, Section } from 'tgui-core/components';

import { AirAlarmControlHome } from './screens/Home';
import { AirAlarmControlModes } from './screens/Modes';
import { AirAlarmControlScrubbers } from './screens/Scrubbers';
import { AirAlarmControlThresholds } from './screens/Thresholds';
import { AirAlarmControlVents } from './screens/Vents';
import type { AlarmScreen } from './types';

export const AIR_ALARM_ROUTES = {
  home: {
    title: 'Воздушные системы управления',
    component: AirAlarmControlHome,
  },
  vents: {
    title: 'Управление вентиляцией',
    component: AirAlarmControlVents,
  },
  scrubbers: {
    title: 'Управление скрубберами',
    component: AirAlarmControlScrubbers,
  },
  modes: {
    title: 'Режим работы',
    component: AirAlarmControlModes,
  },
  thresholds: {
    title: 'Пороги сигнала тревоги',
    component: AirAlarmControlThresholds,
  },
} as const;

export function AirAlarmControl(props) {
  const [screen, setScreen] = useState<AlarmScreen>('home');

  const route = AIR_ALARM_ROUTES[screen] || AIR_ALARM_ROUTES.home;
  const Component = route.component;
  const isHome = route.title === 'Воздушные системы управления';

  return (
    <Section
      fill
      scrollable
      title={route.title}
      buttons={
        <Button
          icon="arrow-left"
          onClick={() => setScreen('home')}
          disabled={isHome}
        >
          Назад
        </Button>
      }
    >
      <Component {...(isHome && { setScreen })} />
    </Section>
  );
}
