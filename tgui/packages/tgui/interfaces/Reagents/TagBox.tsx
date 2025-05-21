import { Button, LabeledList } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { ReagentsData, ReagentsProps } from './types';

export function TagBox(props: ReagentsProps) {
  const { act, data } = useBackend<ReagentsData>();
  const { bitflags, selectedBitflags } = data;

  const [page, setPage] = props.pageState;

  return (
    <LabeledList>
      <LabeledList.Item label="Воздействие">
        <Button
          color={selectedBitflags & bitflags.BRUTE ? 'green' : 'red'}
          icon="gavel"
          onClick={() => {
            act('toggle_tag_brute');
            setPage(1);
          }}
        >
          Физические
        </Button>
        <Button
          color={selectedBitflags & bitflags.BURN ? 'green' : 'red'}
          icon="burn"
          onClick={() => {
            act('toggle_tag_burn');
            setPage(1);
          }}
        >
          Термические
        </Button>
        <Button
          color={selectedBitflags & bitflags.TOXIN ? 'green' : 'red'}
          icon="biohazard"
          onClick={() => {
            act('toggle_tag_toxin');
            setPage(1);
          }}
        >
          Токсины
        </Button>
        <Button
          color={selectedBitflags & bitflags.OXY ? 'green' : 'red'}
          icon="wind"
          onClick={() => {
            act('toggle_tag_oxy');
            setPage(1);
          }}
        >
          Респираторные
        </Button>
        <Button
          color={selectedBitflags & bitflags.ORGAN ? 'green' : 'red'}
          icon="brain"
          onClick={() => {
            act('toggle_tag_organ');
            setPage(1);
          }}
        >
          Органы
        </Button>
        <Button
          icon="flask"
          color={selectedBitflags & bitflags.CHEMICAL ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_chemical');
            setPage(1);
          }}
        >
          Химические
        </Button>
        <Button
          icon="seedling"
          color={selectedBitflags & bitflags.PLANT ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_plant');
            setPage(1);
          }}
        >
          Органические
        </Button>
        <Button
          icon="question"
          color={selectedBitflags & bitflags.OTHER ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_other');
            setPage(1);
          }}
        >
          Прочие
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Тип">
        <Button
          color={selectedBitflags & bitflags.DRINK ? 'green' : 'red'}
          icon="cocktail"
          onClick={() => {
            act('toggle_tag_drink');
            setPage(1);
          }}
        >
          Напитки
        </Button>
        <Button
          color={selectedBitflags & bitflags.FOOD ? 'green' : 'red'}
          icon="drumstick-bite"
          onClick={() => {
            act('toggle_tag_food');
            setPage(1);
          }}
        >
          Еда
        </Button>
        <Button
          color={selectedBitflags & bitflags.HEALING ? 'green' : 'red'}
          icon="medkit"
          onClick={() => {
            act('toggle_tag_healing');
            setPage(1);
          }}
        >
          Исцеление
        </Button>
        <Button
          icon="skull-crossbones"
          color={selectedBitflags & bitflags.DAMAGING ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_damaging');
            setPage(1);
          }}
        >
          Токсины
        </Button>
        <Button
          icon="pills"
          color={selectedBitflags & bitflags.DRUG ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_drug');
            setPage(1);
          }}
        >
          Наркотики
        </Button>
        <Button
          icon="microscope"
          color={selectedBitflags & bitflags.SLIME ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_slime');
            setPage(1);
          }}
        >
          Слизь
        </Button>
        <Button
          icon="bomb"
          color={selectedBitflags & bitflags.EXPLOSIVE ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_explosive');
            setPage(1);
          }}
        >
          Взрывчатка
        </Button>
        <Button
          icon="puzzle-piece"
          color={selectedBitflags & bitflags.UNIQUE ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_unique');
            setPage(1);
          }}
        >
          Уникальное
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Сложность">
        <Button
          icon="chess-pawn"
          color={selectedBitflags & bitflags.EASY ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_easy');
            setPage(1);
          }}
        >
          Лёгкий
        </Button>
        <Button
          icon="chess-knight"
          color={selectedBitflags & bitflags.MODERATE ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_moderate');
            setPage(1);
          }}
        >
          Средний
        </Button>
        <Button
          icon="chess-queen"
          color={selectedBitflags & bitflags.HARD ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_hard');
            setPage(1);
          }}
        >
          Сложный
        </Button>
        <Button
          icon="exclamation-triangle"
          color={selectedBitflags & bitflags.DANGEROUS ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_dangerous');
            setPage(1);
          }}
        >
          Опасный
        </Button>
        <Button
          icon="recycle"
          color={selectedBitflags & bitflags.COMPETITIVE ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_competitive');
            setPage(1);
          }}
        >
          Конкурентный
        </Button>
      </LabeledList.Item>
    </LabeledList>
  );
}
