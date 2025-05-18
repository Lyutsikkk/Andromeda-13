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
            Эксперименты
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
  // const { table, procedures = [], patient = {} } = data; // BUBBER EDIT CHANGE
  const { table, procedures = [], patient = {}, traumas = [] } = data;
  if (!table) {
    return <NoticeBox>Таблица не обнаружена</NoticeBox>;
  }

  return (
    <>
      <Section title="Состояние пациента">
        {Object.keys(patient).length ? (
          <LabeledList>
            <LabeledList.Item label="Статус" color={patient.statstate}>
              {patient.stat}
            </LabeledList.Item>
            <LabeledList.Item label="Группа крови">
              {patient.blood_type || 'Невозможно определить группу крови'}
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
      {/* BUBBER EDIT ADDITION BEGIN - SURGERY COMPUTER INFO */}
      {traumas.map((trauma) => (
        <Section key={trauma.name} title={'Травма: ' + trauma.name}>
          <LabeledList>
            <LabeledList.Item label="Диагноз">{trauma.info}</LabeledList.Item>
            <LabeledList.Item label="Лечение">
              {trauma.treatment}
            </LabeledList.Item>
            {trauma.chems ? (
              <LabeledList.Item label="Химические реакции">
                <NoticeBox info>{trauma.chems}</NoticeBox>
              </LabeledList.Item>
            ) : (
              <LabeledList.Item label="Химические реакции">
                <NoticeBox success>Нету</NoticeBox>
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      ))}
      {/* BUBBER EDIT ADDITION END - SURGERY COMPUTER INFO */}
      {procedures.length === 0 && <Section>Нет активных процедур</Section>}
      {procedures.map((procedure) => (
        <Section key={procedure.name} title={procedure.name}>
          <LabeledList>
            <LabeledList.Item label="Следующий шаг">
              {procedure.next_step}
            </LabeledList.Item>
            {procedure.chems_needed && (
              <LabeledList.Item label="Необходимые химикаты">
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
              <LabeledList.Item label="Необходимые химикаты">
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
