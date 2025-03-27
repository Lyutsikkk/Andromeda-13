import {
  AnimatedNumber,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Tabs,
} from 'tgui-core/components';

import { useBackend, useSharedState } from '../backend';
import { Window } from '../layouts';

const damageTypes = [
  {
    label: 'Физические',
    type: 'bruteLoss',
  },
  {
    label: 'Термические',
    type: 'fireLoss',
  },
  {
    label: 'Токсины',
    type: 'toxLoss',
  },
  {
    label: 'Респираторные',
    type: 'oxyLoss',
  },
];

export const OperatingComputer = (props) => {
  const { act } = useBackend();
  const [tab, setTab] = useSharedState('tab', 1);

  return (
    <Window width={350} height={470}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            Состояние пациента
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            Хирургические процедуры
          </Tabs.Tab>
          <Tabs.Tab onClick={() => act('open_experiments')}>
            эксперименты
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <PatientStateView />}
        {tab === 2 && <SurgeryProceduresView />}
      </Window.Content>
    </Window>
  );
};

const PatientStateView = (props) => {
  const { act, data } = useBackend();
  const { table, procedures = [], patient = {} } = data;
  if (!table) {
    return <NoticeBox>No Table Detected</NoticeBox>;
  }

  return (
    <>
      <Section title="Состояние пациента">
        {Object.keys(patient).length ? (
          <LabeledList>
            <LabeledList.Item label="Состояние" color={patient.statstate}>
              {patient.stat}
            </LabeledList.Item>
            <LabeledList.Item label="Тип крови">
              {patient.blood_type || 'Unable to determine blood type'}
            </LabeledList.Item>
            <LabeledList.Item label="Здоровье">
              <ProgressBar
                value={patient.health}
                minValue={patient.minHealth}
                maxValue={patient.maxHealth}
                color={patient.health >= 0 ? 'good' : 'average'}
              >
                <AnimatedNumber value={patient.health} />
              </ProgressBar>
            </LabeledList.Item>
            {damageTypes.map((type) => (
              <LabeledList.Item key={type.type} label={type.label}>
                <ProgressBar
                  value={patient[type.type] / patient.maxHealth}
                  color="bad"
                >
                  <AnimatedNumber value={patient[type.type]} />
                </ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        ) : (
          'Пациент не обнаружен'
        )}
      </Section>
      {procedures.length === 0 && <Section>Никаких активных процедур</Section>}
      {procedures.map((procedure) => (
        <Section key={procedure.name} title={procedure.name}>
          <LabeledList>
            <LabeledList.Item label="Следующий шаг">
              {procedure.next_step}
            </LabeledList.Item>
            {procedure.chems_needed && (
              <LabeledList.Item label="Необходимые химические вещества">
                <NoticeBox success={procedure.chems_present ? true : false}>
                  {procedure.chems_needed}
                </NoticeBox>
              </LabeledList.Item>
            )}
            {procedure.alternative_step && (
              <LabeledList.Item label="Альтернативный шаг">
                {procedure.alternative_step}
              </LabeledList.Item>
            )}
            {procedure.alt_chems_needed && (
              <LabeledList.Item label="Необходимые химические вещества">
                <NoticeBox success={procedure.alt_chems_present ? true : false}>
                  {procedure.alt_chems_needed}
                </NoticeBox>
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      ))}
    </>
  );
};

const SurgeryProceduresView = (props) => {
  const { act, data } = useBackend();
  const { surgeries = [] } = data;
  return (
    <Section title="Передовые хирургические процедуры">
      <Button
        icon="download"
        content="Синхронизация исследовательской базы данных"
        onClick={() => act('sync')}
      />
      {surgeries.map((surgery) => (
        <Section title={surgery.name} key={surgery.name} level={2}>
          {surgery.desc}
        </Section>
      ))}
    </Section>
  );
};
