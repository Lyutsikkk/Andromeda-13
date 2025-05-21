import {
  Box,
  Button,
  LabeledList,
  Modal,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { formatPower } from 'tgui-core/format';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type TurbineInfo = {
  connected: BooleanLike;
  active: BooleanLike;
  rpm: number;
  power: number;
  temp: number;
  integrity: number;
  max_rpm: number;
  max_temperature: number;
  regulator: number;
};

const TurbineDisplay = (props) => {
  const { act, data } = useBackend<TurbineInfo>();

  return (
    <Section
      title="Статус"
      buttons={
        <Button
          icon={data.active ? 'power-off' : 'times'}
          selected={data.active}
          disabled={!!(data.rpm >= 1000)}
          onClick={() => act('toggle_power')}
        >
          {data.active ? 'Онлайн' : 'Офлайн'}
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Регулятор оборотов">
          <NumberInput
            animated
            value={data.regulator * 100}
            unit="%"
            step={1}
            minValue={1}
            maxValue={100}
            onDrag={(value) =>
              act('regulate', {
                regulate: value * 0.01,
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Целостность турбины">
          <ProgressBar
            value={data.integrity}
            minValue={0}
            maxValue={100}
            ranges={{
              good: [60, 100],
              average: [40, 59],
              bad: [0, 39],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Частота вращения турбины">
          {data.rpm} Об/мин
        </LabeledList.Item>
        <LabeledList.Item label="Макс. частота вращения турбины">
          {data.max_rpm} Об/мин
        </LabeledList.Item>
        <LabeledList.Item label="Входная температура">
          {data.temp} Кельвин
        </LabeledList.Item>
        <LabeledList.Item label="Максимальная температура">
          {data.max_temperature} Кельвин
        </LabeledList.Item>
        <LabeledList.Item label="Генерируемая мощность">
          {formatPower(data.power)}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const OutOfService = (props) => {
  return (
    <Modal>
      <Stack fill vertical>
        <Stack.Item textAlign="center">
          <Box style={{ margin: 'auto' }} textAlign="center" width="300px">
            {
              'Parts not connected, close all mantainence panels/use a multitool on the rotor before trying again'
            }
          </Box>
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

export const TurbineComputer = (props) => {
  const { data } = useBackend<TurbineInfo>();

  return (
    <Window width={310} height={240}>
      <Window.Content>
        {data.connected ? <TurbineDisplay /> : <OutOfService />}
      </Window.Content>
    </Window>
  );
};
