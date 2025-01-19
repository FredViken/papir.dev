import type { PageServerLoad } from './$types';

export const load = (async ({ params }) => {
    return {
        workspace: {
            id: params.workspace,
            name: 'Workspace 1',
        },
    };
}) satisfies PageServerLoad;