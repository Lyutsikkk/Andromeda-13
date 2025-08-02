import {
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { decodeHtmlEntities } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { getGasLabel } from '../../constants';

export type VentProps = {
  refID: string;
  long_name: string;
  power: BooleanLike;
  overclock: BooleanLike;
  integrity: number;
  checks: number;
  excheck: BooleanLike;
  incheck: BooleanLike;
  direction: number;
  external: number;
  internal: number;
  extdefault: number;
  intdefault: number;
};

export type ScrubberProps = {
  refID: string;
  long_name: string;
  power: BooleanLike;
  scrubbing: BooleanLike;
  widenet: BooleanLike;
  filter_types: {
    gas_id: string;
    gas_name: string;
    enabled: BooleanLike;
  }[];
};

export const Vent = (props: VentProps) => {
  const { act } = useBackend();
  const {
    refID,
    long_name,
    power,
    overclock,
    integrity,
    checks,
    excheck,
    incheck,
    direction,
    external,
    internal,
    extdefault,
    intdefault,
  } = props;
  return (
    <Section
      title={decodeHtmlEntities(long_name)}
      buttons={
        <>
          <Button
            icon={power ? 'power-off' : 'times'}
            selected={power}
            disabled={integrity <= 0}
            content={power ? 'Вкл' : 'Выкл'}
            onClick={() =>
              act('power', {
                ref: refID,
                val: Number(!power),
              })
            }
          />
          <Button
            icon="gauge-high"
            color={overclock ? 'green' : 'yellow'}
            disabled={integrity <= 0}
            onClick={() =>
              act('overclock', {
                ref: refID,
              })
            }
            tooltip={`${overclock ? 'Отключить' : 'Включить'} разгон`}
          />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Целостность">
          <p
            title={
              'Разгон позволит вентилятору выдерживать экстремальные условия давления. Однако это также приведет к тому, что со временем вентиляция будет повреждена и в конечном итоге выйдет из строя. Чем ниже уровень целостности, тем менее эффективным будет вентилятор при нормальной работе.'
            }
          >
            {(integrity * 100).toFixed(2)}%
          </p>
        </LabeledList.Item>
        <LabeledList.Item label="Режим">
          <Button
            icon="sign-in-alt"
            content={direction ? 'Нагнетание' : 'Фильтрация'}
            color={!direction && 'danger'}
            onClick={() =>
              act('direction', {
                ref: refID,
                val: Number(!direction),
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Регулятор давления">
          <Button
            icon="sign-in-alt"
            content="Внутренний"
            selected={incheck}
            onClick={() =>
              act('incheck', {
                ref: refID,
                val: checks,
              })
            }
          />
          <Button
            icon="sign-out-alt"
            content="Внешний"
            selected={excheck}
            onClick={() =>
              act('excheck', {
                ref: refID,
                val: checks,
              })
            }
          />
        </LabeledList.Item>
        {!!incheck && (
          <LabeledList.Item label="Внутренняя цель">
            <NumberInput
              value={Math.round(internal)}
              unit="kPa"
              width="75px"
              minValue={0}
              step={10}
              maxValue={5066}
              onChange={(value) =>
                act('set_internal_pressure', {
                  ref: refID,
                  value,
                })
              }
            />
            <Button
              icon="undo"
              disabled={intdefault}
              content="Reset"
              onClick={() =>
                act('reset_internal_pressure', {
                  ref: refID,
                })
              }
            />
          </LabeledList.Item>
        )}
        {!!excheck && (
          <LabeledList.Item label="Внешняя цель">
            <NumberInput
              value={Math.round(external)}
              unit="кПа"
              width="75px"
              minValue={0}
              step={10}
              maxValue={5066}
              onChange={(value) =>
                act('set_external_pressure', {
                  ref: refID,
                  value,
                })
              }
            />
            <Button
              icon="undo"
              disabled={extdefault}
              content="Сбросить"
              onClick={() =>
                act('reset_external_pressure', {
                  ref: refID,
                })
              }
            />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

export const Scrubber = (props: ScrubberProps) => {
  const { act } = useBackend();
  const { long_name, power, scrubbing, refID, widenet, filter_types } = props;
  return (
    <Section
      title={decodeHtmlEntities(long_name)}
      buttons={
        <Button
          icon={power ? 'power-off' : 'times'}
          content={power ? 'Вкл' : 'Выкл'}
          selected={power}
          onClick={() =>
            act('power', {
              ref: refID,
              val: Number(!power),
            })
          }
        />
      }
    >
      <LabeledList>
        <LabeledList.Item label="Режим">
          <Button
            icon={scrubbing ? 'filter' : 'sign-in-alt'}
            color={scrubbing || 'danger'}
            content={scrubbing ? 'Откачивание' : 'Фильтрация'}
            onClick={() =>
              act('scrubbing', {
                ref: refID,
                val: Number(!scrubbing),
              })
            }
          />
          <Button
            icon={widenet ? 'expand' : 'compress'}
            selected={widenet}
            content={widenet ? 'Расширенный диапазон' : 'Нормальный диапазон'}
            onClick={() =>
              act('widenet', {
                ref: refID,
                val: Number(!widenet),
              })
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Фильтры">
          {(scrubbing &&
            filter_types.map((filter) => (
              <Button
                key={filter.gas_id}
                icon={filter.enabled ? 'check-square-o' : 'square-o'}
                tooltip={filter.gas_name}
                selected={filter.enabled}
                onClick={() =>
                  act('toggle_filter', {
                    ref: refID,
                    val: filter.gas_id,
                  })
                }
              >
                {getGasLabel(filter.gas_id, filter.gas_name)}
              </Button>
            ))) ||
            'Нету'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
