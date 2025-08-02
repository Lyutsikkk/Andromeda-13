import { createDropdownInput, type Feature } from '../base';

export const scaling_method: Feature<string> = {
  name: 'Метод масштабирования',
  category: 'ИНТЕРФЕЙС',
  component: createDropdownInput({
    blur: 'Билинейное',
    distort: 'Ближайший Сосед',
    normal: 'Точечный Отбор',
  }),
};
