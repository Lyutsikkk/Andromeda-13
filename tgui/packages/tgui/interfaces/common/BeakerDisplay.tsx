import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../../backend';

export type BeakerReagent = {
  name: string;
  volume: number;
};

export type Beaker = {
  maxVolume: number;
  pH: number;
  currentVolume: number;
  contents: BeakerReagent[];
};

type BeakerProps = {
  beaker: Beaker;
  replace_contents?: BeakerReagent[];
  title_label?: string;
  showpH?: BooleanLike;
};

export const BeakerDisplay = (props: BeakerProps) => {
  const { act } = useBackend();
  const { beaker, replace_contents, title_label, showpH } = props;
  const beakerContents = replace_contents || beaker?.contents || [];

  return (
    <LabeledList>
      <LabeledList.Item
        label="Мензурка"
        buttons={
          !!beaker && (
            <Button icon="eject" onClick={() => act('eject')}>
              Извлечь
            </Button>
          )
        }
      >
        {title_label ||
          (!!beaker && (
            <>
              <AnimatedNumber initial={0} value={beaker.currentVolume} />/
              {beaker.maxVolume} юнитов
            </>
          )) ||
          'Мензурка отсутствует'}
      </LabeledList.Item>
      <LabeledList.Item label="Содержание">
        <Box color="label">
          {(!title_label && !beaker && 'Пусто') ||
            (beakerContents.length === 0 && 'Ничего')}
        </Box>
        {beakerContents.map((chemical) => (
          <Box key={chemical.name} color="label">
            <AnimatedNumber initial={0} value={chemical.volume} /> юнитов{' '}
            {chemical.name}
          </Box>
        ))}
        {beakerContents.length > 0 && !!showpH && (
          <Box>
            pH:
            <AnimatedNumber value={beaker.pH} />
          </Box>
        )}
      </LabeledList.Item>
    </LabeledList>
  );
};

export const BeakerSectionDisplay = (props: BeakerProps) => {
  const { act } = useBackend();
  const { beaker, replace_contents, title_label, showpH } = props;
  const beakerContents = replace_contents || beaker?.contents || [];

  return (
    <Section
      title={title_label || 'Мензурка'}
      buttons={
        !!beaker && (
          <>
            <Box inline color="label" mr={2}>
              {beaker.currentVolume} / {beaker.maxVolume} юнитов
            </Box>
            <Button icon="eject" onClick={() => act('eject')}>
              Извлечь
            </Button>
          </>
        )
      }
    >
      <Box color="label">
        {(!beaker && 'Пусто') || (beakerContents.length === 0 && 'Ничего')}
      </Box>
      {beakerContents.map((chemical) => (
        <Box key={chemical.name} color="label">
          <AnimatedNumber initial={0} value={chemical.volume} /> юнитов{' '}
          {chemical.name}
        </Box>
      ))}
      {beakerContents.length > 0 && !!showpH && (
        <Box>
          pH:
          <AnimatedNumber value={beaker.pH} />
        </Box>
      )}
    </Section>
  );
};
