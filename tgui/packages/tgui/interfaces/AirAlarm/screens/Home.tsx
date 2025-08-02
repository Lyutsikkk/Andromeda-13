import type { Dispatch, SetStateAction } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

import type { AirAlarmData, AlarmScreen } from '../types';

type Props = {
  setScreen?: Dispatch<SetStateAction<AlarmScreen>>;
};

export function AirAlarmControlHome(props: Props) {
  const { act, data } = useBackend<AirAlarmData>();
  const { setScreen } = props;
  if (!setScreen) {
    throw new Error('setScreen is required');
  }

  const {
    allowLinkChange,
    atmosAlarm,
    filteringPath,
    panicSiphonPath,
    selectedModePath,
    sensor,
  } = data;

  const isPanicSiphoning = selectedModePath === panicSiphonPath;
  return (
    <Stack vertical>
      <Stack.Item>
        <Button
          icon={atmosAlarm ? 'exclamation-triangle' : 'exclamation'}
          color={atmosAlarm && 'caution'}
          onClick={() => act(atmosAlarm ? 'reset' : 'alarm')}
        >
          Сигнализация атмосферы в зоне
        </Button>
      </Stack.Item>
      <Stack.Item mb={1}>
        <Button
          icon={isPanicSiphoning ? 'exclamation-triangle' : 'exclamation'}
          color={isPanicSiphoning && 'danger'}
          onClick={() =>
            act('mode', {
              mode: isPanicSiphoning ? filteringPath : panicSiphonPath,
            })
          }
        >
          Аварийная откачка воздуха
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button icon="sign-out-alt" onClick={() => setScreen('vents')}>
          Управление вентиляцией
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button icon="filter" onClick={() => setScreen('scrubbers')}>
          Управление скрубберами
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button icon="cog" onClick={() => setScreen('modes')}>
          Режим работы
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button icon="chart-bar" onClick={() => setScreen('thresholds')}>
          Пороги сигнала тревоги
        </Button>
      </Stack.Item>
      {!!sensor && !!allowLinkChange && (
        <Stack.Item>
          <Button.Confirm
            icon="link-slash"
            color="danger"
            onClick={() => act('disconnect_sensor')}
          >
            Отсоедините сенсер
          </Button.Confirm>
        </Stack.Item>
      )}
    </Stack>
  );
}
