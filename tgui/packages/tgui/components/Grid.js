import { pureComponentHooks } from 'common/react';
import { Box } from './Box';

export const Grid = props => {
  const {
    columns,
    rows,
    gridSize,
    children,
    ...rest
  } = props;
  const columnEmpty = [];
  const rowEmpty = [];

  // Some spaghetti code to make -ms-grid work properly
  for (let i = 1; i <= columns+1; i++) {
    columnEmpty.push(<Box width={gridSize} height={gridSize} style={{ "-ms-grid-column": i, "-ms-grid-row": 1 }} />);
  }

  for (let i = 2; i <= rows+1; i++) {
    rowEmpty.push(<Box width={gridSize} height={gridSize} style={{ "-ms-grid-column": 1, "-ms-grid-row": i }} />);
  }

  return (
    <Box style={{ "display": "-ms-grid" }} {...rest}>
      {columnEmpty}
      {rowEmpty}
      {children}
    </Box>
  );
};

export const GridItem = props => {
  const {
    firstColumn,
    firstRow,
    secondColumn,
    secondRow,
    children,
    ...rest
  } = props;

  return (
    <Box style={{ "-ms-grid-column": firstColumn, "-ms-grid-row": firstRow, "-ms-grid-column-span": secondColumn, "-ms-grid-row-span": secondRow }} {...rest}>
      {children}
    </Box>
  );
};

Grid.defaultHooks = pureComponentHooks;
GridItem.defaultHooks = pureComponentHooks;
Grid.Item = GridItem;
