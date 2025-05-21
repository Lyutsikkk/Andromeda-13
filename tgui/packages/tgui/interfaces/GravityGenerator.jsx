import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const GravityGenerator = (props) => {
  const { data } = useBackend();
  const { operational } = data;
  return (
    <Window width={400} height={155}>
      <Window.Content>
        {!operational && <NoticeBox>Нет данных</NoticeBox>}
        {!!operational && <GravityGeneratorContent />}
      </Window.Content>
    </Window>
  );
};

const GravityGeneratorContent = (props) => {
  const { act, data } = useBackend();
  const { breaker, charge_count, charging_state, on, operational } = data;
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Питание">
          <Button
            icon={breaker ? 'power-off' : 'times'}
            content={breaker ? 'Вкл' : 'Выкл'}
            selected={breaker}
            disabled={!operational}
            onClick={() => act('gentoggle')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Заряд гравитации">
          <ProgressBar
            value={charge_count / 100}
            ranges={{
              good: [0.7, Infinity],
              average: [0.3, 0.7],
              bad: [-Infinity, 0.3],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Режим зарядки">
          {charging_state === 0 &&
            ((on && <Box color="good">Полностью заряжен</Box>) || (
              <Box color="bad">Не заряжается</Box>
            ))}
          {charging_state === 1 && <Box color="average">Зарядка</Box>}
          {charging_state === 2 && <Box color="average">Разрядка</Box>}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
