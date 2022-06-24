import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Button, ByondUi, Input, Section, Dropdown, Flex, Stack } from '../components';
import { refocusLayout, Window } from '../layouts';

/**
 * Camera selector.
 *
 * Filters cameras, applies search terms and sorts the alphabetically.
 */
const selectCameras = (cameras, searchText = '', networkFilter = '') => {
  const testSearch = createSearch(searchText, camera => camera.name);
  let fl = flow([
    // Null camera filter
    filter(camera => camera?.name),
    // Optional search term
    searchText && filter(testSearch),
    // Optional network filter
    networkFilter && filter(camera => camera.networks.includes(networkFilter)),
    // Slightly expensive, but way better than sorting in BYOND
    sortBy(camera => camera.name),
  ])(cameras);
  return fl;
};

export const CameraConsole = (props, context) => {
  return (
    <Window
      width={870}
      height={708}
      resizable>
      <CameraConsoleContent />
    </Window>
  );
};

export const CameraConsoleContent = (props, context) => {
  const { act, data, config } = useBackend(context);

  const { mapRef, activeCamera } = data;
  const cameras = selectCameras(data.cameras);
  return (
    <Fragment>
      <div className="CameraConsole__left">
        <CameraConsoleSearch />
      </div>
      <div className="CameraConsole__right">
        <div className="CameraConsole__toolbar">
          <b>Camera: </b>
          {activeCamera
            && activeCamera.name
            || '—'}
        </div>
        <div className="CameraConsole__toolbarRight">
          <Button
            icon="chevron-left"
            onClick={() => act('pan', { dir: 8 })} />
          <Button
            icon="chevron-up"
            onClick={() => act('pan', { dir: 1 })} />
          <Button
            icon="chevron-right"
            onClick={() => act('pan', { dir: 4 })} />
          <Button
            icon="chevron-down"
            onClick={() => act('pan', { dir: 2 })} />
        </div>
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: mapRef,
            type: 'map',
          }} />
      </div>
    </Fragment>
  );
};

export const CameraConsoleSearch = (props, context) => {
  const { act, data } = useBackend(context);
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  const [
    networkFilter,
    setNetworkFilter,
  ] = useLocalState(context, 'networkFilter', '');
  const { activeCamera, allNetworks } = data;
  allNetworks.sort();
  const cameras = selectCameras(data.cameras, searchText, networkFilter);
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Input
          fluid
          mb={1}
          placeholder="Search for a camera"
          onInput={(e, value) => setSearchText(value)} />
        <Dropdown
          mb={1}
          width="177px"
          options={allNetworks}
          placeholder="No Filter"
          onSelected={value => setNetworkFilter(value)} />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          {cameras.map(camera => (
            // We're not using the component here because performance
            // would be absolutely abysmal (50+ ms for each re-render).
            <div
              key={camera.name}
              title={camera.name}
              className={classes([
                'Button',
                'Button--fluid',
                'Button--color--transparent',
                'Button--ellipsis',
                activeCamera
                  && camera.name === activeCamera.name
                  && 'Button--selected',
              ])}
              onClick={() => {
                refocusLayout();
                act('switch_camera', {
                  name: camera.name,
                });
              }}>
              {camera.name}
            </div>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
